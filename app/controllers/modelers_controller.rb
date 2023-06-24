class ModelersController < ApplicationController
  skip_before_action :authenticate_user!

  def show
    @modeling_project = ModelingProject.find_by(slug: params[:id]) || ModelingProject.find(params[:id])
    @entered_password_cookie = cookies[:entered_password_cookie]
  end

  def create
    @modeling_project = ModelingProject.find_by(slug: params[:id]) || ModelingProject.find(params[:id])

    if @modeling_project.modeler_password == params[:password]
      cookies[:entered_password_cookie] = params[:password]
      redirect_to modeler_path(@modeling_project), notice: "password correct"
    else
      redirect_to modeler_path(@modeling_project), alert: 'incorrect password'
    end
  end

	def download_upload
		@modeling_project = ModelingProject.find_by(slug: params[:id]) || ModelingProject.find(params[:id])
		@entered_password_cookie = cookies[:entered_password_cookie]

		if @modeling_project.modeler_password.present? && @entered_password_cookie.present? && @entered_password_cookie == @modeling_project.modeler_password
			@upload = Upload.find(params[:upload_id])
			@data = open(@upload.file.service_url)

			send_data @data.read, filename: @upload.file.filename.to_s, stream: true
		else
			redirect_to modeler_path(@modeling_project), alert: "you don't have access to that file"
		end
	end
end
