class ApplicationController < ActionController::Base
	protect_from_forgery with: :null_session
	before_action :authenticate_user!
	before_action :verify_name_present
	before_action :configure_permitted_parameters, if: :devise_controller?
	before_action :prepare_exception_notifier
	# before_action :check_if_beta_approved

	helper_method :current_cart
	def current_cart
		current_user.current_cart if current_user.present?
	end

	def after_sign_in_path_for(resource)
		if resource.class.name == "AdminUser"
			admin_root_path
		else
			dashboard_path
		end
	end

	def after_sign_out_path_for(resource_or_scope)
		if resource_or_scope == :admin_user
			admin_root_path
		else
			root_path
		end
	end

	def page_not_found
	end

	private
	def verify_name_present
		redirect_to enter_name_users_path if !devise_controller? && user_signed_in? && !current_user.name.present?
	end

	def check_if_beta_approved
		redirect_to :beta_login, alert: 'you need to enter the beta password first' if (!cookies[:beta_password].present? || cookies[:beta_password] != ENV['BETA_PASSWORD']) && (params[:action] != "beta_login" && params[:action] != "beta_login_submit")
	end

	def configure_permitted_parameters
		devise_parameter_sanitizer.permit(:sign_up, keys: [:email, :password, :password_confirmation, :name])
		devise_parameter_sanitizer.permit(:account_update, keys: [:email, :password, :password_confirmation, :name, :address_line_one, :address_line_two, :state, :city, :zip_code, :country, :profile_picture])
	end

	def prepare_exception_notifier
		request.env["exception_notifier.exception_data"] = {
			:current_user => (current_user.present? ? current_user.email : 'Not Logged In')
		}
	end
end
