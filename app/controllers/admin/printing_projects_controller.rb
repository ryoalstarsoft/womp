class Admin::PrintingProjectsController < Admin::AdminController
  before_action :set_printing_project, only: [:show, :edit, :update, :destroy]

  def show
  end

  def edit
  end

  def update
    if @printing_project.update_attributes(printing_project_params)
      @printing_project.send_rejected_email if printing_project_params[:material_id] == "" # the material id will have been reset, meaning womp denied the project in it's current form
      @printing_project.send_emails unless printing_project_params[:workspace_id].present?

      redirect_to admin_printing_project_path(@printing_project)
    else
      flash[:alert] = @printing_project.errors.full_messages.to_sentence.downcase
      redirect_back fallback_location: admin_printing_project_path(@printing_project)
    end
  end

  private
  def set_printing_project
    @printing_project = PrintingProject.find_by(slug: params[:slug]) || PrintingProject.find(params[:slug])
  end

  def printing_project_params
    params.require(:printing_project).permit(
      :workspace_id,
      :material_id,
      :price_override,
      :womp_approved,
      :picked_up,
      :tracking_number,
      :carrier
    )
  end
end
