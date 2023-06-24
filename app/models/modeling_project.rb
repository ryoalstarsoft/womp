class ModelingProject < ApplicationRecord
  attr_accessor :reviewable, # reviewable is used in conjunction with temp_uploads for determining if a model is meant for user review
    :mark_project_incomplete, # mark_project_incomplete is used to reverse an accepted model
    :allowed_for_modeler_upload_ids # used for marking uploads available for modelers to see

	after_create :update_identifier
	after_update :update_status, if: Proc.new {|p| p.status != calculate_status}

	belongs_to :user
	belongs_to :workspace, optional: true
	belongs_to :cart, optional: true
	belongs_to :order, optional: true

	belongs_to :previous_version_modeling_project, class_name: 'ModelingProject', optional: true
	has_one :next_version_modeling_project, class_name: 'ModelingProject', foreign_key: :previous_version_modeling_project_id

	has_many_attached :temp_uploads
	validate :temp_uploads_correct_filetypes_and_size

	has_many :uploads, as: :projectable, dependent: :destroy
  accepts_nested_attributes_for :uploads, reject_if: :all_blank
	has_many :comments, as: :projectable, dependent: :destroy

	# Status
	def create_project_complete?
		name.present?
	end

	def calculate_status
		if !create_project_complete?
			"creating project"
		elsif !user_captioned?
			"captioning visual references"
		elsif !user_reviewed?
			"user reviewing"
		elsif !pricing_group.present?
			"womp reviewing"
		elsif !paid?
			"checkout"
		elsif !uploads.where.not(admin_user_id: nil).where(accepted: true).present? || uploads.where.not(admin_user_id: nil).where(released_to_user: false).select{|u| u.file_type == "3d_model"}.present?
			"3d modeling"
		else
			"complete"
		end
	end

  def model_at
		10.business_days.after(self.paid_at)
	end

	# Configuration
  def display_name
		name.present? ? "#{name} - #{created_at.strftime('%D')}" : created_at.strftime('%D')
	end

	def to_param
		slug
	end

  def total_price
    if price_override.present?
      price_override.to_f
    else
      hash = { "nurbs_a": 5, "nurbs_b": 20, "nurbs_c": 40, "nurbs_d": 100, "nurbs_e": 200, "vector_to_nu_a": 10, "vector_to_nu_b": 20, "mesh_to_nure_a": 100, "mesh_to_nure_b": 250,
					"mesh_to_nure_c": 500, "mesh_a": 200, "para_a": 250, "para_b": 50, "extra_a": 200, "extra_b": 50, "extra_c": 20, "extra_d": 0, "extra_e": 10, "extra_e_one": 20, "extra_e_two": 50 }
			hash[:"#{pricing_group}"].present? ? hash[:"#{pricing_group}"] : 0
    end
  end

  # Action Items
  def send_new_version_email
    ModelingProjectMailer.new_version(self, self.previous_version_modeling_project).deliver
  end

  def send_emails
    unless cart_id.present? || uploads.where.not(admin_user_id: nil).where(released_to_user: false, reviewable: true).select{|u| u.file_type == "3d_model"}.present? # don't send emails if there are models that the user isn't allowed to see
      if paid? && uploads.where(reviewable: true, accepted: true).present?
        ModelingProjectMailer.model_accepted(self).deliver
      elsif paid? && uploads.where(reviewable: true).present?
        ModelingProjectMailer.time_to_review(self).deliver
      elsif paid?
        ModelingProjectMailer.time_to_model(self).deliver
      elsif create_project_complete? && pricing_group.present?
        ModelingProjectMailer.payment_requested(self).deliver
      elsif create_project_complete? && user_captioned? && user_reviewed? && !pricing_group.present?
        ModelingProjectMailer.project_created(self).deliver
      end
    end
  end

  def create_uploads(user_object, upload_reviewable = false)
    if user_object.is_a?(AdminUser)
      admin_user_id = user_object.id
      user_id = nil
    else
      admin_user_id = nil
      user_id = user_object.id
    end

    self.temp_uploads.each do |active_storage_attachment|
      upload = uploads.create!(
        admin_user_id: admin_user_id,
        user_id: user_id,
        reviewable: upload_reviewable
      )

      active_storage_attachment.update_attributes(name: "file", record_type: "Upload", record_id: upload.id)

      upload.enqueue_calcuations
    end
  end

  def update_status # is called from outside model sometimes so can't be private
		update_attributes(status: calculate_status)
	end

	private
	# Lifecycle Events
	def update_identifier
		if ModelingProject.where.not(id: self.id).present? && !slug.present?
			update_attributes(slug: ModelingProject.where.not(id: self.id).order('slug asc').last.slug.to_i + 1)
		elsif !slug.present?
			update_attributes(slug: "#{100000 + id}")
		end
	end

	# Validations
	def temp_uploads_correct_filetypes_and_size
		temp_uploads.each do |temp_upload|
			if temp_upload.byte_size > 350000000
				temp_upload.purge
				errors.add('file', 'is too large')
			else
				validate_pdf(temp_upload) if File.extname(temp_upload.filename.to_s) == ".pdf"

				if !%w(.stl .obj .png .jpg .jpeg .svg .pdf).include?(File.extname(temp_upload.filename.to_s))
					temp_upload.purge
					errors.add('file', 'must be a valid file type')
				elsif reviewable == "true" && !%w(.stl .obj).include?(File.extname(temp_upload.filename.to_s))
					temp_upload.purge
					errors.add('file', 'must be a 3d model')
				end
			end
		end
	end

	def validate_pdf(temp_upload)
		io = open(temp_upload.service_url)

		begin
			reader = PDF::Reader.new(io)

			if reader.page_count > 1
				temp_upload.purge
				errors.add('pdf', 'must not be longer than one page')
			end
		rescue # some pdf's have weird bytesizes that PDF::Reader can't parse, so we rescue the error
			errors.add('pdf', 'must not be longer than one page')
		end
	end
end
