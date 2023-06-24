class ScanningProject < ApplicationRecord
	attr_accessor :purge_scanning_images

	after_create :update_identifier
	after_update :update_status, if: Proc.new {|p| p.status != calculate_status}

	belongs_to :user
	belongs_to :workspace, optional: true
	belongs_to :cart, optional: true
	belongs_to :order, optional: true

	has_one_attached :front_image
	validate :front_image_is_image
	has_one_attached :back_image
	validate :back_image_is_image
	has_one_attached :right_image
	validate :right_image_is_image
	has_one_attached :left_image
	validate :left_image_is_image
	has_one_attached :top_image
	validate :top_image_is_image
	has_one_attached :bottom_image
	validate :bottom_image_is_image

	has_one_attached :temp_upload
	validate :temp_upload_is_model

	has_one :upload, as: :projectable, dependent: :destroy
  has_many :comments, as: :projectable, dependent: :destroy

	# Status
	def create_project_complete?
		name.present? && object_size.present?
	end

	def all_images_attached?
		front_image.attached? && back_image.attached? && top_image.attached? && bottom_image.attached? && right_image.attached? && left_image.attached?
	end

	def scanning_details_complete?
		resolution.present? && color.present? && all_images_attached?
	end

	def exact_size_present?
		length.present? && width.present? && height.present?
	end

	def enter_address_complete?
		user.address.present?
	end

	def calculate_status
		if !create_project_complete? || (object_size == "other" && !exact_size_present?)
			"creating project"
		elsif !resolution.present?
			"entering resolution"
		elsif !color.present?
			"entering color"
		elsif !all_images_attached?
			"attaching images"
		elsif !user_reviewed? && object_size == "other"
			"user reviewing"
		elsif !price_override.present? && object_size == "other"
			"womp reviewing"
		elsif !enter_address_complete?
			"entering address"
		elsif !paid?
			"checkout"
		elsif !upload.present?
			"womp scanning"
		else
			"complete"
		end
	end

	def model_at
		10.business_days.after(self.received_at)
	end

	# Configuration
	def display_name
		name.present? ? "#{name} - #{created_at.strftime('%D')}" : created_at.strftime('%D')
	end

	def to_param
		slug
	end

	def total_price
		if price_override.present? || object_size == "other"
			price_override.to_f
		else
			base = 0
			base += resolution_cost(resolution)
			base += color_cost(color)
			return base
		end
	end

	def resolution_cost(resolution_level)
		if resolution_level.nil? || resolution_level == ""
			return 0
		elsif object_size == "one_inch_to_six_inches"
			return 150 if resolution_level == "medium"
			return 300 if resolution_level == "high"
		elsif object_size == "seven_inches_to_twenty_four_inches"
			return 150 if resolution_level == "low"
			return 200 if resolution_level == "medium"
			return 400 if resolution_level == "high"
		elsif object_size == "twenty_five_inches_to_thirty_two_inches"
			return 250 if resolution_level == "low"
			return 300 if resolution_level == "medium"
			return 600 if resolution_level == "high"
		elsif object_size == "thirty_three_inches_to_fifty_six_inches"
			return 300 if resolution_level == "low"
			return 400 if resolution_level == "medium"
			return 800 if resolution_level == "high"
		end
	end

	def color_cost(color_level)
		if color_level.nil? || color_level == ""
			return 0
		elsif color_level == "no_color"
			return 0
		elsif object_size == "one_inch_to_six_inches" || object_size == "seven_inches_to_twenty_four_inches"
			return 100
		elsif object_size == "twenty_five_inches_to_thirty_two_inches" || object_size == "thirty_three_inches_to_fifty_six_inches"
			return 150
		end
	end

	def display_scanning_object_size
		if object_size == "other"
			"other"
		elsif object_size == "one_inch_to_six_inches"
			'1" - 6"'
		elsif object_size == "seven_inches_to_twenty_four_inches"
			'7" - 24"'
		elsif object_size == "twenty_five_inches_to_thirty_two_inches"
			'25" - 32"'
		elsif object_size == "thirty_three_inches_to_fifty_six_inches"
			'33" - 56"'
		end
	end

	# Action Items
	def purge_all_images
		front_image.purge
		right_image.purge
		top_image.purge
		back_image.purge
		left_image.purge
		bottom_image.purge
	end

	def send_emails
		unless cart_id.present? || (upload.present? && upload.released_to_user == false)
			if paid? && womp_received? && upload.present? && tracking_number.present? && carrier.present?
				ScanningProjectMailer.shipped(self).deliver
			elsif paid? && womp_received? && upload.present? && picked_up?
				ScanningProjectMailer.picked_up(self).deliver
			elsif paid? && womp_received? && upload.present?
				ScanningProjectMailer.complete(self).deliver
			elsif paid? && womp_received? && !upload.present?
				ScanningProjectMailer.womp_received(self).deliver
			elsif paid? && !womp_received?
				ScanningProjectMailer.project_created(self).deliver
			elsif user_reviewed? && price_override.present? && object_size == "other"
				ScanningProjectMailer.payment_requested(self).deliver
			elsif user_reviewed? && !price_override.present? && object_size == "other"
				ScanningProjectMailer.womp_review_needed(self).deliver
			end
		end
	end

	def create_upload(user_object)
		if temp_upload.attached?
			self.create_upload!(admin_user_id: user_object.id)
			temp_upload.update_attributes(name: "file", record_type: "Upload", record_id: self.upload.id)
			self.upload.enqueue_calcuations
		end
	end

	def update_status # is called from outside model sometimes so can't be private
		update_attributes(status: calculate_status)
	end

	private
	# Lifecycle Events
	def update_identifier
		if ScanningProject.where.not(id: self.id).present? && !slug.present?
			update_attributes(slug: ScanningProject.where.not(id: self.id).order('slug asc').last.slug.to_i + 1)
		elsif !slug.present?
			update_attributes(slug: "#{100000 + id}")
		end
	end

	# Validations
	def temp_upload_is_model
		if temp_upload.attached?
			if temp_upload.byte_size > 350000000
				temp_upload.purge
				errors.add('file', 'is too large')
			elsif !['.stl', '.obj'].include?(File.extname(temp_upload.filename.to_s))
				temp_upload.purge
				errors.add('file', 'mist be an .stl or .obj file')
			end
		end
	end

	def front_image_is_image
		if front_image.attached?
			if front_image.blob.byte_size > 10000000
				front_image.purge
				errors.add('front image', 'must be smaller than 10mb')
			elsif !front_image.blob.content_type.starts_with?('image/')
				front_image.purge
				errors.add('front image', 'must be an image')
			end
		end
	end

	def right_image_is_image
		if right_image.attached?
			if right_image.blob.byte_size > 10000000
				right_image.purge
				errors.add('right image', 'must be smaller than 10mb')
			elsif !right_image.blob.content_type.starts_with?('image/')
				right_image.purge
				errors.add('right image', 'must be an image')
			end
		end
	end

	def top_image_is_image
		if top_image.attached?
			if top_image.blob.byte_size > 10000000
				top_image.purge
				errors.add('top image', 'must be smaller than 10mb')
			elsif !top_image.blob.content_type.starts_with?('image/')
				top_image.purge
				errors.add('top image', 'must be an image')
			end
		end
	end

	def back_image_is_image
		if back_image.attached?
			if back_image.blob.byte_size > 10000000
				back_image.purge
				errors.add('back image', 'must be smaller than 10mb')
			elsif !back_image.blob.content_type.starts_with?('image/')
				back_image.purge
				errors.add('back image', 'must be an image')
			end
		end
	end

	def left_image_is_image
		if left_image.attached?
			if left_image.blob.byte_size > 10000000
				left_image.purge
				errors.add('left image', 'must be smaller than 10mb')
			elsif !left_image.blob.content_type.starts_with?('image/')
				left_image.purge
				errors.add('left image', 'must be an image')
			end
		end
	end

	def bottom_image_is_image
		if bottom_image.attached?
			if bottom_image.blob.byte_size > 10000000
				bottom_image.purge
				errors.add('bottom image', 'must be smaller than 10mb')
			elsif !bottom_image.blob.content_type.starts_with?('image/')
				bottom_image.purge
				errors.add('bottom image', 'must be an image')
			end
		end
	end
end
