class ScanningProjectMailer < ApplicationMailer
  def project_created(scanning_project)
		@scanning_project = scanning_project

		mail(to: AdminUser.where(receive_emails: true).map{|u| u.email}.join(", "), subject: "Scanning Project Created - #{Date.today.strftime('%D')}")
	end

	def payment_requested(scanning_project)
		@scanning_project = scanning_project

		mail(to: @scanning_project.user.email, subject: "Payment Requested for Your Womp Scanning Project")
	end

	def womp_review_needed(scanning_project)
		@scanning_project = scanning_project

		mail(to: AdminUser.where(receive_emails: true).map{|u| u.email}.join(", "), subject: "Scanning Project Needs Review - #{Date.today.strftime('%D')}")
	end

	def womp_received(scanning_project)
		@scanning_project = scanning_project

		mail(to: @scanning_project.user.email, subject: "Womp Has Received Your Model")
	end

	def complete(scanning_project)
		@scanning_project = scanning_project

		mail(to: @scanning_project.user.email, subject: "Womp Has Completed Your Scan")
	end

	def shipped(scanning_project)
		@scanning_project = scanning_project

		mail(to: @scanning_project.user.email, subject: "Womp Has Shipped Your Model")
	end

	def picked_up(scanning_project)
		@scanning_project = scanning_project

		mail(to: @scanning_project.user.email, subject: "Womp Has Marked Your Object As Received")
	end
end
