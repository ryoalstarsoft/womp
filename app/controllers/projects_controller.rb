class ProjectsController < ApplicationController
	def new
	end

	def show
		@project = current_user.projects.find_by(slug: params[:slug]) || current_user.projects.find(params[:slug])

		if @project.project_type == "scanning"
			redirect_to scanning_project_path(params[:slug])
		elsif @project.project_type == "modeling"
			redirect_to modeling_project_path(params[:slug])
		elsif @proejct.project_type == "printing"
			redirect_to printing_project_path(params[:slug])
		end
	end
end
