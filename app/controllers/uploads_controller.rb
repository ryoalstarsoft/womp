class UploadsController < ApplicationController
	skip_before_action :verify_authenticity_token, only: :update_annotations
	skip_before_action :authenticate_user!, only: [:nexus, :smoothing, :upload_ready]

	def show
		@upload = current_user.uploads.find(params[:id])
	end

	def annotate
		@upload = Upload.find(params[:id])

		respond_to do |format|
			format.js
		end
	end

	def create
		@upload = Upload.create!(
			project_id: create_upload_params[:project_id],
			user_id: current_user.id
		)

		@upload.construct_file_from_data(create_upload_params[:viewer_image], create_upload_params[:viewer_filename])

		respond_to do |format|
			format.js
		end
	end

	def update
		@upload = Upload.find(params[:id])

		if @upload.update_attributes(update_upload_params)
			@upload.projectable.send_emails

			redirect_to @upload.projectable
		else
			redirect_to @upload.projectable, alert: 'something went wrong'
		end
	end

	def destroy
		@upload = Upload.find(params[:id])
		@upload.destroy

		redirect_to @upload.projectable
	end

	def update_annotations
		@upload = Upload.find(params[:id])
		@upload.annotations.destroy_all

		params[:_json].each do |annotation|
			@upload.annotations.create!(
				x: annotation[:geometry][:x],
				y: annotation[:geometry][:y],
				width: annotation[:geometry][:width],
				height: annotation[:geometry][:height],
				annotation_type: annotation[:geometry][:type],
				text: annotation[:data][:text],
				color: annotation[:data][:color]
			)
		end

		render json: {}
	end

	def clone
		@upload = Upload.find(params[:id])

		tmp_file_path = Rails.root.join("tmp", @upload.file.filename.to_s).to_s

		File.open(tmp_file_path, "wb") do |file|
			file.write open(@upload.file.service_url(expires_in: 1.week)).read
		end

		@new_upload = @upload.project.uploads.create!(
			user_id: current_user.id,
			admin_user_id: nil,
			description: @upload.description
		)

		@new_upload.file.attach(io: File.open(tmp_file_path), filename: @upload.file.filename.to_s)
		@new_upload.enqueue_calcuations

		FileUtils.rm(tmp_file_path)

		redirect_back(fallback_location: project_path(@upload.project), notice: "file duplicated")
	end

	def download
		@upload = current_user.uploads.find(params[:id])
		@data = open(@upload.file.service_url)

		send_data @data.read, filename: @upload.file.filename.to_s, stream: true
	end

	def nexus
		@upload = Upload.find(params[:id])

		nxs_link = "https://s3.amazonaws.com/#{ENV['S3_BUCKET']}/#{params[:upload_uuid]}"

		if @upload.update_attributes(
			nxs_link: nxs_link,
			volume: params[:machine_space][:volume],
			surface_area: params[:machine_space][:surfaceArea],
			bounding_box_volume: params[:machine_space][:boundingBoxVolume],
			bounding_box_x: params[:machine_space][:boundingBoxX],
			bounding_box_y: params[:machine_space][:boundingBoxY],
			bounding_box_z: params[:machine_space][:boundingBoxZ],
			machine_space: params[:machine_space][:machineSpace]
		)
			render json: { success: true }
		else
			render json: { success: false }
		end
	end

	def smoothing
		@upload = Upload.find(params[:id])
		@upload.update_attributes(smoothing: !@upload.smoothing)

		render json: { success: true }
	end

	def upload_ready
		@upload = Upload.find(params[:id])

		if @upload.is_viewer_ready?
			render json: { ready: true }
		else
			render json: { ready: false }
		end
	end

	private
	# there are two upload params filters for security reasons
	def create_upload_params
		params.require(:upload).permit(
			:project_id,
			:viewer_image,
			:viewer_filename
		)
	end

	def update_upload_params
		params.require(:upload).permit(:accepted)
	end
end
