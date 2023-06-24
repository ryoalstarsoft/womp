class CommentsController < ApplicationController
	def create
		@comment = Comment.new(comment_params)

		if @comment.save
			@comment.send_emails
			@comment.create_uploads(current_user)
			@comment.create_existing_attachments(current_user, comment_params[:temp_existing_attachment_ids])
			redirect_back(fallback_location: @comment.projectable)
		else
			redirect_back(fallback_location: @comment.projectable, alert: @comment.errors.full_messages.to_sentence.downcase)
		end
	end

	private
	def comment_params
		params.require(:comment).permit(
			:user_id,
			:project_id,
			:projectable_id,
			:projectable_type,
			:body,
			:temp_existing_attachment_ids,
			:temp_uploads,
			temp_uploads: [],
			temp_existing_attachment_ids: []
		)
	end
end
