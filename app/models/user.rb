require 'securerandom'

class User < ApplicationRecord
	devise :database_authenticatable, :registerable, :recoverable, :rememberable, :trackable, :validatable, :omniauthable, omniauth_providers: [:facebook, :google_oauth2]

	has_many :scanning_projects, dependent: :destroy
	has_many :modeling_projects, dependent: :destroy
	has_many :printing_projects, dependent: :destroy
	has_many :projects, dependent: :destroy
	has_many :comments, dependent: :destroy
	has_many :authentications, dependent: :destroy
	has_one :cart, dependent: :destroy
	has_many :orders, dependent: :destroy

	has_one_attached :profile_picture

	validate :profile_picture_correct_filetype_and_size, if: Proc.new { |u| u.profile_picture.attached? }

	# users should have access to uploads that admins have uploaded to their projects as well
	def uploads
		project_upload_ids = []

		self.scanning_projects.includes(:upload).each do |scanning_project|
			project_upload_ids.push([scanning_project.upload.id]) if scanning_project.upload.present?
		end
		self.modeling_projects.includes(:uploads).each do |modeling_project|
			project_upload_ids.push(modeling_project.uploads.ids)
		end
		self.printing_projects.includes(:uploads).each do |printing_project|
			project_upload_ids.push(printing_project.uploads.ids)
		end

		return Upload.where(id: project_upload_ids.flatten.uniq)
	end

	def apply_omniauth(omniauth)
		self.name = omniauth['info']['name']
		self.email = omniauth['info']['email']
		self.password = SecureRandom.urlsafe_base64 if self.password.nil?

		if omniauth['info']['image'].present?
			filename = "#{omniauth['info']['name']}.jpeg"
			tmp_file_path = Rails.root.join("tmp", filename)

			File.open(tmp_file_path, "wb") do |file|
				file.write open("#{omniauth['info']['image']}?type=large").read
			end

			self.profile_picture.attach(io: File.open(tmp_file_path), filename: filename)
		end

		authentications.build(provider: omniauth['provider'], uid: omniauth['uid'])
	end

	def address
		if address_line_one.present?
			computated_address_line_two = address_line_two.present? ? " #{address_line_two}" : ""
			address_state = state.present? ? " #{state} " : " "

			return "#{address_line_one}#{computated_address_line_two}, #{city},#{address_state}#{zip_code}"
		else
			nil
		end
	end

	def current_cart
		if !self.cart.present?
			self.create_cart!
		end

		self.cart
	end

	private
	def profile_picture_correct_filetype_and_size
		if !%w(.png .jpg .jpeg).include?(File.extname(profile_picture.blob.filename.to_s))
			profile_picture.purge
			errors.add('profile picture', 'must be an image')
		end
	end
end
