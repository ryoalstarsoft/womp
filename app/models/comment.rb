class Comment < ApplicationRecord
	attr_accessor :temp_existing_attachment_ids

	belongs_to :projectable, polymorphic: true, optional: true

	belongs_to :user, optional: true
	belongs_to :admin_user, optional: true
	belongs_to :project, optional: true
	has_many :comment_uploads, dependent: :destroy
	has_many :uploads, through: :comment_uploads

	has_many_attached :temp_uploads

	validate :presence_of_body_or_temp_files
	validate :temp_uploads_correct_filetypes_and_size

	def commenter_name
		if user.present?
			user.name.present? ? user.name : user.email
		else
			'womp'
		end
	end

	def send_emails
		CommentMailer.create(self).deliver!
	end

	def create_uploads(user_object)
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
				projectable: self.projectable
			)

			active_storage_attachment.update_attributes(name: "file", record_type: "Upload", record_id: upload.id)

			upload.enqueue_calcuations
		end
	end

	def create_existing_attachments(current_user, temp_existing_attachment_ids)
		if temp_existing_attachment_ids.present?
			existing_attachments = current_user.uploads.where(id: temp_existing_attachment_ids)

			existing_attachments.each do |upload|
				if upload.projectable == self.projectable # don't duplicate the upload, just attach it to the comment
					self.comment_uploads.create!(
						upload_id: upload.id
					)
				else # duplicate the upload, attaching it to the comment AND the project
					filename = upload.file.blob.filename.to_s
					tmp_file_path = Rails.root.join("tmp", filename).to_s

					File.open(tmp_file_path, "wb") do |file|
						file.write open(upload.file.blob.service_url(expires_in: 1.week)).read
					end

					new_upload = self.uploads.create!(
						projectable: self.projectable,
						user_id: current_user.id
					)

					new_upload.file.attach(io: File.open(tmp_file_path), filename: filename).to_s

					new_upload.enqueue_calcuations
				end
			end
		end
	end

	private
	def presence_of_body_or_temp_files
		errors.add('comment', 'must have body or file upload') if !temp_uploads.present? && !temp_existing_attachment_ids.present? && !body.present?
	end

	def temp_uploads_correct_filetypes_and_size
		temp_uploads.each do |temp_upload|
			if temp_upload.blob.byte_size > 350000000
				temp_upload.purge
				errors.add('file', 'is too large')
			else
				if File.extname(temp_upload.blob.filename.to_s) == ".pdf"
					io = open(temp_upload.blob.service_url)

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

				if !%w(.stl .obj .png .jpg .jpeg .svg .pdf).include?(File.extname(temp_upload.blob.filename.to_s))
					temp_upload.purge
					errors.add('file', 'must be a valid file type')
				end
			end
		end
	end
end
