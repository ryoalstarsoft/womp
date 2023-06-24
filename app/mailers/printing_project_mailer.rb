class PrintingProjectMailer < ApplicationMailer
	def time_to_review(printing_project)
		@printing_project = printing_project

		mail(to: AdminUser.where(receive_emails: true).map{|u| u.email}.join(", "), subject: "It's Time to Review - #{Date.today.strftime('%D')}")
	end

	def payment_requested(printing_project)
		@printing_project = printing_project

		mail(to: @printing_project.user.email, subject: "Payment Requested for Your Womp Printing Project")
	end

	def time_to_print(printing_project)
		@printing_project = printing_project

		mail(to: AdminUser.where(receive_emails: true).map{|u| u.email}.join(", "), subject: "It's Time To Print - #{Date.today.strftime('%D')}")
	end

	def print_shipped(printing_project)
		@printing_project = printing_project

		mail(to: @printing_project.user.email, subject: "Your Print Has Shipped")
	end

	def print_picked_up(printing_project)
		@printing_project = printing_project

		mail(to: @printing_project.user.email, subject: "Womp Has Marked Your Object As Received")
	end

	def rejected(printing_project)
		@printing_project = printing_project

		mail(to: @printing_project.user.email, subject: "Your Print Settings Have Been Rejected")
	end
end
