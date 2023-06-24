class Upload < ApplicationRecord
	require 'open-uri'
	include ActionView::Helpers::TextHelper

	attr_accessor :viewer_image, :viewer_filename # raw image data sent from JS screenshots

	belongs_to :projectable, polymorphic: true, optional: true

	belongs_to :project, optional: true
	has_many :annotations, dependent: :destroy
	has_many :comment_uploads, dependent: :destroy
	has_many :comments, through: :comment_uploads

	has_one_attached :file

	after_update :update_project_status
	after_destroy :update_project_status

	def thirty_minutes_old?
		DateTime.now.utc.to_i - created_at.utc.to_i > 1800 ? true : false
	end

	def file_image_url
		if file.previewable?
			file.preview(resize: "2550x3300").processed.service_url
		else
			file.service_url
		end
	end

	def filename_with_annotations
		if annotations.present?
			"#{file.filename.to_s} - #{created_at.strftime('%D')} - #{pluralize(annotations.count, 'annotation')}"
		else
			"#{file.filename.to_s} - #{created_at.strftime('%D')}"
		end
	end

	def is_viewer_ready?
		volume.present? && surface_area.present? && bounding_box_volume.present? && bounding_box_x.present? && bounding_box_y.present? && bounding_box_z.present? && machine_space.present? && viewer_link.present?
	end

	def viewer_link
		if ENV['SKIP_MICROSERVICE'].present? && ENV['SKIP_MICROSERVICE'] == 'true'
			'https://s3.amazonaws.com/womp-platform-development/andra.nxs'
		else
			nxs_link
		end
	end

	def annotate_read_only(user_object)
		if user_object.class == User
			user_id == nil
		elsif user_object.class == AdminUser
			admin_user_id == nil
		end
	end

	def price_from_material(material)
		price = 0

		if material.present?
			# note: all prices are in cm^3 so must do some conversions
			steel_ids = [141, 142, 143, 144, 145, 146, 147, 148]

			if steel_ids.include?(material.id) && (bounding_box_volume / 1000) >= 1000
				price += 7.0 # base price
				price += 0.30 * (bounding_box_volume / 1000) # divide by 1000 to convert to cm^3)
				price += 0.80 * (volume / 1000) # divide by 1000 to convert to cm^3)
			else
				price += material.per_part_price
				price += material.support_price
				price += material.handling_price
				price += (material.surface_area_price * (surface_area / 100)) # divide by 100 to convert to cm^2
				price += (material.volume_price * (volume / 1000)) # divide by 1000 to convert to cm^3)
				price += (material.bounding_box_price * (bounding_box_volume / 1000)) # divide by 1000 to convert to cm^3
				price += (material.machine_space_price * (machine_space / 1000)) # divide by 100 to convert to cm^3
			end
		end

		return price * 1.2 # add 20% to all prices
	end

	def construct_file_from_data(image, filename)
		tmp_file_path = Rails.root.join("tmp", filename).to_s
		jpg = Base64.decode64(image['data:image/jpeg;base64,'.length .. -1])

		File.open(tmp_file_path, "wb") do |file|
			file.write jpg
		end

		file.attach(io: File.open(tmp_file_path), filename: filename)
	end

	def formatted_annotations
		annotation_array = annotations.map{ |annotation|
			{
				"id": annotation.id,
				"geometry": {
					"x": annotation.x,
					"y": annotation.y,
					"width": annotation.width,
					"height": annotation.height,
					"type": annotation.annotation_type
				},
				"data": {
					"text": annotation.text,
					"id": annotation.id,
					"color": annotation.color
				}
			}
		}

		return annotation_array
	end

	def file_type
		if self.file.attached?
			case File.extname(self.file.filename.to_s.downcase)
			when '.jpg', '.png', '.gif'
				return 'image'
			when '.pdf', '.doc', '.docx', '.csv', '.xls', '.xlsx', '.txt'
				return 'file'
			when '.3dc', '.3ds', '.ac', '.abc', '.bvh', '.blend', '.geo', '.dae', '.zae', '.dwf', '.dw', '.x', '.dxf',
				'.fbx', '.ogr', '.gta', '.gltf', '.glb', '.igs', '.iges', '.stl', '.obj', '.vrml', '.x3g', '.ply', '.gltf',
				'.igs', '.iges', '.mu', '.craft', '.kmz', '.las', '.lwo', '.lws', '.q3d', '.mc2obj', '.dat', '.flt', '.iv',
				'.osg', '.osgb', '.osgterrain', '.osgtgz', '.osgx', '.ive', '.ply', '.bsp', '.md2', '.mdl', '.shp', '.stl',
				'.sta', '.txp', '.vpx', '.wrl', '.vrml', '.wrz'
				return '3d_model'
			when '.zip', '.rar', '.7z', '.gzip'
				return 'compressed'
			end
		end
	end

	def enqueue_calcuations
		UploadJob.perform_later(self.id) if ['.stl', '.obj'].include?(File.extname(self.file.filename.to_s)) && !is_viewer_ready?
	end

	def perform_nxs_conversion
		link = "https://s3.amazonaws.com/#{ENV['S3_BUCKET']}/#{self.file.blob.key}" # the microservice has read access to this link without a signed request

		if file.blob.byte_size > 75000000
			queue = "large_conversions"
		else
			queue = "conversions"
		end

		result = HTTParty.post("#{ENV['MICROSERVICE_BASE_URL']}/encode",
			body: {
				upload_id: self.id,
				callback_url: "#{ENV['CALLBACK_URL']}/uploads/#{self.id}/nexus",
				link: link,
				original_filename: self.file.filename.to_s,
				bucket: ENV['S3_BUCKET'],
				queue: queue
			}.to_json,
			headers: { 'Content-Type' => 'application/json'}
		)

		if result["success"].present? && result["success"] == true
			# we don't do anything with the result because a background job has been queued on the microservice server
		else
			raise "something went wrong with calculations"
		end
	end

	def update_project_status
		self.projectable.update_attributes(status: self.projectable.calculate_status) if self.projectable.present?
	end
end
