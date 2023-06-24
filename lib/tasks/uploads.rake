require 'aws-sdk-s3'
require 'securerandom'

namespace :port do
	desc 'Moves Uploads to S3'
	task :uploads_to_aws => :environment do
		Upload.where.not(original_filename: nil).each do |upload|
			tmp_file_path = Rails.root.join("tmp", sanitize_filename(upload.original_filename)).to_s

			File.open(tmp_file_path, "wb") do |file|
				puts "Downloading file..."
				file.write open(upload.link).read
			end

			upload.file.attach(io: File.open(tmp_file_path), filename: sanitize_filename(upload.original_filename).to_s)
		end
	end
end

namespace :cleanup do
	task :tmp_uploads => :environment do
		Upload.where.not(original_filename: nil).each do |upload|
			tmp_file_path = Rails.root.join("tmp", sanitize_filename(upload.original_filename)).to_s

			begin
				FileUtils.rm(tmp_file_path)
			rescue
				# do nothing
			end
		end
	end
end

namespace :update do
	task :reviewable_uploads => :environment do
		Upload.where.not(admin_user_id: nil).select{|upload| upload.file_type == "3d_model"}.each do |upload|
			upload.update_attributes(reviewable: true)
		end
	end
end

def sanitize_filename(filename)
	# Split the name when finding a period which is preceded by some
	# character, and is followed by some character other than a period,
	# if there is no following period that is followed by something
	# other than a period (yeah, confusing, I know)
	fn = filename.split /(?<=.)\.(?=[^.])(?!.*\.[^.])/m

	# We now have one or two parts (depending on whether we could find
	# a suitable period). For each of these parts, replace any unwanted
	# sequence of characters with an underscore
	fn.map! { |s| s.gsub /[^a-z0-9\-]+/i, '_' }

	# Finally, join the parts with a period and return the result
	return fn.join '.'
end

namespace :make do
	task :last_upload_viewer_ready => :environment do
		Upload.last.update_attributes(
			nxs_link: 'https://s3.amazonaws.com/womp-platform-development/andra.nxs',
			volume: 100,
			surface_area: 100,
			bounding_box_volume: 100,
			bounding_box_x: 100,
			bounding_box_y: 100,
			bounding_box_z: 100,
			machine_space: 100
		)
	end
end
