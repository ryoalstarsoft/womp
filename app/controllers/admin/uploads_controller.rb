class Admin::UploadsController < Admin::AdminController
	skip_before_action :verify_authenticity_token, only: :update_annotations

	def index # for printing calculator
		@uploads = Upload.order('created_at desc').includes(file_attachment: :blob).select{|u| u.file_type == "3d_model"}
	end

	def printing_prices # for printing calculator
		@upload = Upload.find(params[:id])
		@materials = Material.where.not(material_category: nil)
	end

	def upload_printing_price_upload # for printing calculator
		@upload = Upload.new(printing_price_upload_params)

		if @upload.save
			@upload.enqueue_calcuations
			redirect_to printing_prices_admin_upload_path(@upload)
		else
			redirect_back(fallback_location: admin_uploads_path, alert: 'something went wrong')
		end
	end

	def update
		@upload = Upload.find(params[:id])

		if @upload.update_attributes(params.require(:upload).permit(:released_to_user))
			@upload.projectable.send_emails
			@upload.projectable.update_attributes(status: @upload.projectable.calculate_status)

			redirect_to correct_project_path(@upload), notice: 'scan has been released to user'
		else
			redirect_back(fallback_location: correct_project_path(@upload), alert: 'something went wrong')
		end
	end

  def show
		@upload = Upload.find(params[:id])
	end

  def annotate
    @upload = Upload.find(params[:id])

    respond_to do |format|
      format.js
    end
  end

  def destroy
    @upload = Upload.find(params[:id])
    @upload.destroy

    redirect_to correct_project_path(@upload)
  end

  def create
		@upload = Upload.create!(
			project_id: create_upload_params[:project_id],
			admin_user_id: current_admin_user.id
		)

		@upload.construct_file_from_data(create_upload_params[:viewer_image], create_upload_params[:viewer_filename])

		respond_to do |format|
			format.js
		end
	end

  def clone
		@upload = Upload.find(params[:id])

		tmp_file_path = Rails.root.join("tmp", @upload.file.filename.to_s).to_s

		File.open(tmp_file_path, "wb") do |file|
			file.write open(@upload.file.service_url(expires_in: 1.week)).read
		end

		@new_upload = @upload.project.uploads.create!(
			user_id: nil,
			admin_user_id: current_admin_user.id,
			description: @upload.description
		)

		@new_upload.file.attach(io: File.open(tmp_file_path), filename: @upload.file.filename.to_s)
		@new_upload.enqueue_calcuations

		FileUtils.rm(tmp_file_path)

		redirect_back(fallback_location: correct_project_path(@upload), notice: "file duplicated")
	end

  def download
		@upload = Upload.find(params[:id])
		@data = open(@upload.file.service_url)

		send_data @data.read, filename: @upload.file.filename.to_s, stream: true
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

  private
	def correct_project_path(upload)
		if upload.projectable_type == "ScanningProject"
			admin_scanning_project_path(upload.projectable)
		elsif upload.projectable_type == "ModelingProject"
			admin_modeling_project_path(upload.projectable)
		end
	end

  def create_upload_params
    params.require(:upload).permit(
			:project_id,
			:viewer_image,
			:viewer_filename
		)
  end

	def printing_price_upload_params
		params.require(:upload).permit(
			:file
		)
	end
end
