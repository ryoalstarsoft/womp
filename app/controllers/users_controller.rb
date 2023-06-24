class UsersController < ApplicationController
	skip_before_action :verify_name_present

	def update
		if current_user.update_attributes(user_params)
			if user_params[:name].present?
				redirect_to dashboard_path, notice: "name added"
			else
				current_user.scanning_projects.each do |scanning_project|
					scanning_project.update_status
				end
				current_user.modeling_projects.each do |modeling_project|
					modeling_project.update_status
				end
				current_user.printing_projects.each do |printing_project|
					printing_project.update_status
				end
				redirect_back(fallback_location: root_path)
			end
		else
			redirect_back(fallback_location: root_path, alert: 'something went wrong')
		end
	end

	def enter_name
	end

	private
	def user_params
		params.require(:user).permit(
			:name,
			:address_line_one,
			:address_line_two,
			:state,
			:city,
			:zip_code,
			:country
		)
	end
end
