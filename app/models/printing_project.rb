class PrintingProject < ApplicationRecord
	attr_accessor :delete_last_upload # used to "go back" from choose materials to re-upload a model

	after_create :update_identifier
	after_update :update_status, if: Proc.new {|p| p.status != calculate_status}

	belongs_to :user
	belongs_to :material, optional: true
	belongs_to :workspace, optional: true
	belongs_to :cart, optional: true
	belongs_to :order, optional: true

	has_many_attached :temp_uploads
	validate :temp_uploads_correct_filetypes_and_size

	has_many :uploads, as: :projectable, dependent: :destroy
	has_many :comments, as: :projectable, dependent: :destroy

	# Status
	def create_project_complete?
		name.present? && uploads.present?
	end

	def enter_address_complete?
		user.address.present?
	end

	def calculate_status
		if !create_project_complete?
			"creating project"
		elsif !material.present?
			"choose materials"
		elsif !womp_approved?
			"womp reviewing"
		elsif !paid?
			"checkout"
		elsif !tracking_number.present? && !picked_up?
			"printing"
		else
			"complete"
		end
	end

	# Configuration
	def to_param
		slug
	end

	def printing_price
		if self.material.present?
			uploads.last.price_from_material(self.material)
		else
			0
		end
	end

	def total_price
		if price_override.present?
			price_override.to_f * quantity.to_f
		else
			printing_price.to_f * quantity.to_f
		end
	end

	# Action Items
	def send_emails
		unless cart_id.present?
			if material.present? && !womp_approved?
				PrintingProjectMailer.time_to_review(self).deliver
			elsif womp_approved? && !paid?
				PrintingProjectMailer.payment_requested(self).deliver
			elsif paid? && !tracking_number.present? && !picked_up?
				PrintingProjectMailer.time_to_print(self).deliver
			elsif tracking_number.present?
				PrintingProjectMailer.print_shipped(self).deliver
			elsif picked_up?
				PrintingProjectMailer.print_picked_up(self).deliver
			end
		end
	end

	def send_rejected_email
		PrintingProjectMailer.rejected(self).deliver
	end

	def create_uploads(user_object, upload_reviewable = false)
		self.temp_uploads.each do |active_storage_attachment|
			upload = uploads.create!(
				user_id: user_object.id,
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
		if PrintingProject.where.not(id: self.id).present? && !slug.present?
			update_attributes(slug: PrintingProject.where.not(id: self.id).order('slug asc').last.slug.to_i + 1)
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
			elsif !%w(.stl .obj).include?(File.extname(temp_upload.filename.to_s))
				temp_upload.purge
				errors.add('file', 'must be a 3d model')
			end
		end
	end
end
