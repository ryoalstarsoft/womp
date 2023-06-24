class Admin::CommentsController < Admin::AdminController
  def create
		@comment = Comment.new(comment_params)

		if @comment.save
			@comment.send_emails
			@comment.create_uploads(current_admin_user)

			redirect_back(fallback_location: fallback_path(@comment))
		else
			redirect_back(fallback_location: fallback_path(@comment), alert: "something went wrong")
		end
	end

  def destroy
    @comment = Comment.find(params[:id])
    @comment.destroy

    redirect_back(fallback_location: fallback_path(@comment))
  end

	private
  def fallback_path(comment)
    if comment.projectable_type == "ScanningProject"
      admin_scanning_project_path(comment.projectable)
    elsif comment.projectable_type == "ModelingProject"
      admin_modeling_project_path(comment.projectable)
    end
  end

	def comment_params
		params.require(:comment).permit(
			:admin_user_id,
			:project_id,
			:body,
      :projectable_id,
      :projectable_type,
			:temp_existing_attachment_ids,
			:temp_uploads,
			temp_uploads: [],
			temp_existing_attachment_ids: []
		)
	end
end
