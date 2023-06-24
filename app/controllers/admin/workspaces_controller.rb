class Admin::WorkspacesController < Admin::AdminController
	before_action :set_workspace, only: [:show, :edit, :update, :destroy]

	def index
		@workspaces = Workspace.all
	end

	def show
	end

	def new
	end

	def edit
	end

	def create
		@workspace = Workspace.new(workspace_params)

		if @workspace.save
			redirect_to admin_workspace_path(@workspace)
		else
			render action: :new
		end
	end

	def update
		if @workspace.update_attributes(workspace_params)
			redirect_to admin_workspace_path(@workspace)
		else
			render action: :edit
		end
	end

	def destroy
		@workspace.destroy

		redirect_to admin_workspaces_path
	end

	private
	def set_workspace
		@workspace = Workspace.find(params[:id])
	end

	def workspace_params
		params.require(:workspace).permit(
			:name
		)
	end
end
