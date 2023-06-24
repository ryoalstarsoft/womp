class Admin::AdminUsersController < Admin::AdminController
	before_action :set_admin_user, only: [:show, :edit, :update, :destroy]

	def index
		@admin_users = AdminUser.all
	end

	def show
	end

	def new
	end

	def edit
	end

	def create
		@admin_user = AdminUser.new(admin_user_params)

		if @admin_user.save
			redirect_to admin_admin_user_path(@admin_user)
		else
			render action: :new
		end
	end

	def update
		if admin_user_params[:password].present? || admin_user_params[:password_confirmation].present?
			if admin_user_params[:password] == admin_user_params[:password_confirmation] && @admin_user.update_attributes(admin_user_params)
				redirect_to admin_admin_user_path(@admin_user)
			else
				render action: :edit
			end
		else
			if @admin_user.update_without_password(admin_user_params)
				redirect_to admin_admin_user_path(@admin_user)
			else
				render action: :edit
			end
		end
	end

	def destroy
		@admin_user.destroy

		redirect_to admin_admin_users_path
	end

	private
	def set_admin_user
		@admin_user = AdminUser.find(params[:id])
	end

	def admin_user_params
		params.require(:admin_user).permit(
			:email,
			:password,
			:password_confirmation,
			:receive_emails
		)
	end
end
