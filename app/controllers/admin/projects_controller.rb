class Admin::ProjectsController < Admin::AdminController
	def index
		@scanning_projects = ScanningProject.order('created_at desc')
		@modeling_projects = ModelingProject.includes(
			:next_version_modeling_project
		).order('created_at desc').select{|modeling_project| !modeling_project.next_version_modeling_project.present?}
		@printing_projects = PrintingProject.order('created_at desc')
	end

	def show
		@project = Project.find_by(slug: params[:slug]) || Project.find(params[:slug])

		if @project.project_type == "scanning"
			redirect_to admin_scanning_project_path(params[:slug])
		elsif @project.project_type == "modeling"
			redirect_to admin_modeling_project_path(params[:slug])
		elsif @proejct.project_type == "printing"
			redirect_to admin_printing_project_path(params[:slug])
		end
	end
end
