class CommentMailer < ApplicationMailer
	def create(comment)
		@comment = comment
		@notifyee = comment.user.present? ? AdminUser.where(receive_emails: true).map{|u| u.email}.join(", ") : comment.projectable.user.email

		mail(to: @notifyee, subject: "New Comment on Your Womp Project")
	end
end
