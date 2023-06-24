class HomeController < ApplicationController
	skip_before_action :authenticate_user!
	# skip_before_action :check_if_beta_approved

	def index
	end

	def beta_login
	end

	def beta_login_submit
		if params[:beta_password] && params[:beta_password] == ENV['BETA_PASSWORD']
			cookies[:beta_password] = params[:beta_password]
			redirect_to root_path
		else
			redirect_to beta_login_path, alert: "incorrect password"
		end
	end

	def how_it_works
		@title = "Womp 3D Services - How It Works"
	end

	def materials
		# @title = "Womp 3D Services - Materials"
		# params[:q] = params[:q].present? ? params[:q].reject{|_, v| v.blank?} : nil
		#
		# # There's old links to materials somewhere on the internet with a color_cont filter applied that needs to be removed
		# if params[:q].present? && params[:q][:color_cont].present?
		# 	params[:q].delete(:color_cont)
		# end
		#
		# @q = Material.ransack(params[:q])
		# @materials = @q.result.where.not(archived: true).where.not(name: "name")
		#
		# @colors = Material.where.not(archived: true).where.not(name: "name").colors
		#
		# respond_to do |format|
		# 	format.html
		# 	format.js
		# end
		redirect_to root_path, alert: 'this page has temporarily been removed'
	end

	def terms_and_conditions
		@title = "Womp 3D Services - Terms and Conditions"
	end

	def faq
		@title = "Womp 3D Services - FAQ"
	end

	def about_us
		@title = "Womp 3D Services - About Us"
	end
end
