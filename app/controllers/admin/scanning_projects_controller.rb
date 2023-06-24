class Admin::ScanningProjectsController < Admin::AdminController
  before_action :set_scanning_project, only: [:show, :edit, :update, :destroy]

  def show
  end

  def update
    if @scanning_project.update_attributes(scanning_project_params)
      @scanning_project.create_upload(current_admin_user) # this has to go before emails
      @scanning_project.send_emails unless scanning_project_params[:workspace_id].present? # don't send emails if we're only updating the workspace

      redirect_to admin_scanning_project_path(@scanning_project)
    else
      flash[:alert] = @scanning_project.errors.full_messages.to_sentence.downcase
      redirect_back fallback_location: admin_scanning_project_path(@scanning_project)
    end
  end

  private
  def set_scanning_project
    @scanning_project = ScanningProject.find_by(slug: params[:slug]) || ScanningProject.find(params[:slug])
  end

  def scanning_project_params
    params.require(:scanning_project).permit(
      :workspace_id,
      :price_override,
      :womp_received,
      :received_at,
      :temp_upload,
      :tracking_number,
      :carrier,
      :picked_up
    )
  end
end
