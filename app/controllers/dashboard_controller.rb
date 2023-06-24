class DashboardController < ApplicationController
	def index
		@scanning_projects = current_user.scanning_projects.order('created_at desc')
		@modeling_projects = current_user.modeling_projects.order('created_at desc')
		@printing_projects = current_user.printing_projects.order('created_at desc')
		@uploads = current_user.modeling_projects.map{|p| p.uploads.includes(file_attachment: :blob)}.flatten
	end

	def search_projects
		params[:q] = params[:q].present? ? params[:q].reject{|_, v| v.blank?} : nil

		@scanning_projects_ransack = current_user.scanning_projects.ransack(params[:q])
		@scanning_projects = @scanning_projects_ransack.result
		@modeling_projects_ransack = current_user.modeling_projects.ransack(params[:q])
		@modeling_projects = @modeling_projects_ransack.result.includes(
			:next_version_modeling_project
		)
		@printing_projects_ransack = current_user.printing_projects.ransack(params[:q])
		@printing_projects = @printing_projects_ransack.result

		@uploads = current_user.modeling_projects.map{|p| p.uploads.includes(file_attachment: :blob)}.flatten

		respond_to do |format|
			format.js
		end
	end
end
