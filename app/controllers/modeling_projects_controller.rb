class ModelingProjectsController < ApplicationController
  before_action :set_modeling_project, only: [:show, :update, :destroy]

  def create
    @modeling_project = ModelingProject.new(modeling_project_params)

    if @modeling_project.save
      redirect_to modeling_project_path(@modeling_project)
    else
      redirect_to new_project_path, alert: 'something went wrong'
    end
  end

  def update
    if @modeling_project.update_attributes(modeling_project_params)
      @modeling_project.update_attributes(name: "modeling ##{@modeling_project.slug}") if !@modeling_project.name.present?
      @modeling_project.update_attributes(user_captioned: true) if @modeling_project.create_project_complete? && !modeling_project_params[:temp_uploads].present? && !modeling_project_params[:user_captioned].present? # user may upload more files before proceeding to the review step
      @modeling_project.create_uploads(current_user) # converts temp_uploads to upload model
      @modeling_project.send_emails unless modeling_project_params[:cart_id] == ""

      if (modeling_project_params[:cart_id].present? || modeling_project_params[:cart_id] == "") && modeling_project_params.keys.count == 1 # only updating the cart
        redirect_to cart_path
      else
        redirect_to modeling_project_path(@modeling_project)
      end
    else
      flash[:alert] = @modeling_project.errors.full_messages.to_sentence.downcase
      render action: :show
    end
  end

  def destroy
    @modeling_project.destroy
    redirect_to dashboard_path
  end

  def show
    redirect_to modeling_project_path(@modeling_project) if params[:slug].to_i - 100000 < 0
    @modeling_project.comments.update_all(viewed: true)
  end

  private
  def set_modeling_project
    @modeling_project = current_user.modeling_projects.find_by(slug: params[:slug]) || current_user.modeling_projects.find(params[:slug])
  end

  def modeling_project_params
    params.require(:modeling_project).permit(
      :user_id,
      :name,
      :description,
      :user_captioned,
      :user_reviewed,
      :cart_id,
      :temp_uploads,
      temp_uploads: [],
      uploads_attributes: [
        :id,
        :description
      ]
    )
  end
end
