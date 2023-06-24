class ModelingProjectMailer < ApplicationMailer
  def project_created(modeling_project)
		@modeling_project = modeling_project

		mail(to: AdminUser.where(receive_emails: true).map{|u| u.email}.join(", "), subject: "Modeling Project Created - #{Date.today.strftime('%D')}")
	end

	def payment_requested(modeling_project)
		@modeling_project = modeling_project

		mail(to: @modeling_project.user.email, subject: "Payment Requested for Your Womp Modeling Project")
	end

	def time_to_model(modeling_project)
		@modeling_project = modeling_project

		mail(to: AdminUser.where(receive_emails: true).map{|u| u.email}.join(", "), subject: "It's Time To Model - #{Date.today.strftime('%D')}")
	end

	def time_to_review(modeling_project)
		@modeling_project = modeling_project

		mail(to: @modeling_project.user.email, subject: "A New Model Has Been Uploaded for Your Womp Modeling Project")
	end

	def model_accepted(modeling_project)
		@modeling_project = modeling_project

		mail(to: AdminUser.where(receive_emails: true).map{|u| u.email}.join(", "), subject: "A Model Has Been Accepted - #{Date.today.strftime('%D')}")
	end

	def new_version(new_modeling_project, previous_modeling_project)
		@new_modeling_project = new_modeling_project
		@previous_modeling_project = previous_modeling_project

		mail(to: @new_modeling_project.user.email, subject: "Payment Requested for Your Womp Modeling Project")
	end
end
