class ScanningProjectsController < ApplicationController
	before_action :set_scanning_project, only: [:show, :edit, :update, :destroy]

	def create
		@scanning_project = ScanningProject.new(scanning_project_params)

		if @scanning_project.save
			redirect_to scanning_project_path(@scanning_project)
		else
			redirect_to new_project_path, alert: 'something went wrong'
		end
	end

	def update
		if !params[:scanning_project].present?
			# only time this wouldn't be present is during attach images submit
			redirect_to(@scanning_project, alert: 'you must attach all images')
		elsif @scanning_project.update_attributes(scanning_project_params)
			@scanning_project.update_attributes(name: "scanning ##{@scanning_project.slug}") if !@scanning_project.name.present?
			@scanning_project.purge_all_images if scanning_project_params[:purge_scanning_images].present?
			@scanning_project.send_emails unless scanning_project_params[:cart_id] == ""

			if (scanning_project_params[:cart_id].present? || scanning_project_params[:cart_id] == "") && scanning_project_params.keys.count == 1 # only updating the cart
				redirect_to cart_path
			else
				redirect_to scanning_project_path(@scanning_project)
			end
		else
			flash[:alert] = @scanning_project.errors.full_messages.to_sentence.downcase
			render action: :show
		end
	end

	def destroy
		@scanning_project.destroy
		redirect_to dashboard_path
	end

	def show
		redirect_to scanning_project_path(@scanning_project) if params[:slug].to_i - 100000 < 0
		@scanning_project.comments.update_all(viewed: true)
	end

	def edit
	end

	private
	def set_scanning_project
		@scanning_project = current_user.scanning_projects.find_by(slug: params[:slug]) || current_user.scanning_projects.find(params[:slug])
	end

	def scanning_project_params
		params.require(:scanning_project).permit(
			:user_id,
			:name,
			:object_size,
			:length,
			:width,
			:height,
			:resolution,
			:color,
			:front_image,
			:back_image,
			:right_image,
			:left_image,
			:top_image,
			:bottom_image,
			:user_reviewed,
			:purge_scanning_images,
			:cart_id
		)
	end
end
