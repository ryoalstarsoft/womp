class UploadJob < ApplicationJob
	queue_as :default

	# Performs calculations using microservice
	def perform(upload_id)
		upload = Upload.find(upload_id)

		upload.perform_nxs_conversion unless ENV['SKIP_MICROSERVICE'].present? && ENV['SKIP_MICROSERVICE'] == 'true'
	end
end
