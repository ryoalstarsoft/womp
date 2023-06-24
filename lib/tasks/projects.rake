namespace :port do
	desc 'Creates new project identifiers...'
	task :slugs => :environment do
		Project.all.each do |project|
			puts "Porting project #{project.id}..."

			project.update_attributes(slug: "#{100000 + project.id}")
		end
	end

	desc 'Moves Projects with type Scanning to Scanning Project Table'
	task :scanning_projects => :environment do
		puts "Beginning Port Process"

		Project.where(project_type: 'scanning').each do |project|
			puts "Porting #{project.slug}"

			scanning_project = ScanningProject.create!(
				user_id: project.user_id,
				cart_id: project.cart_id,
				order_id: project.order_id,
				workspace_id: project.workspace_id,
				slug: project.slug,
				name: project.name,
				status: project.status,
				object_size: project.object_size,
				length: project.length,
				width: project.width,
				height: project.height,
				resolution: project.resolution,
				color: project.color,
				paid: project.paid,
				paid_at: project.paid_at,
				final_price: project.final_price,
				user_reviewed: project.user_reviewed,
				price_override: project.price_override,
				womp_received: project.womp_received,
				received_at: project.received_at,
				tracking_number: project.tracking_number,
				carrier: project.carrier,
				picked_up: project.picked_up,
				created_at: project.created_at
			)

			project.comments.each do |comment|
				comment.update_attributes(projectable_id: scanning_project.id, projectable_type: "ScanningProject")
			end
			project.uploads.each do |upload|
				upload.update_attributes(projectable_id: scanning_project.id, projectable_type: "ScanningProject")
			end

			if project.front_image.attached?
				tmp_file_path = Rails.root.join("tmp", project.front_image.blob.filename.to_s)
				File.open(tmp_file_path, "wb") do |file|
					file.write open(project.front_image.service_url).read
				end
				scanning_project.front_image.attach(io: File.open(tmp_file_path), filename: project.front_image.blob.filename.to_s)
			end
			if project.back_image.attached?
				tmp_file_path = Rails.root.join("tmp", project.back_image.blob.filename.to_s)
				File.open(tmp_file_path, "wb") do |file|
					file.write open(project.back_image.service_url).read
				end
				scanning_project.back_image.attach(io: File.open(tmp_file_path), filename: project.back_image.blob.filename.to_s)
			end
			if project.left_image.attached?
				tmp_file_path = Rails.root.join("tmp", project.left_image.blob.filename.to_s)
				File.open(tmp_file_path, "wb") do |file|
					file.write open(project.left_image.service_url).read
				end
				scanning_project.left_image.attach(io: File.open(tmp_file_path), filename: project.left_image.blob.filename.to_s)
			end
			if project.right_image.attached?
				tmp_file_path = Rails.root.join("tmp", project.right_image.blob.filename.to_s)
				File.open(tmp_file_path, "wb") do |file|
					file.write open(project.right_image.service_url).read
				end
				scanning_project.right_image.attach(io: File.open(tmp_file_path), filename: project.right_image.blob.filename.to_s)
			end
			if project.top_image.attached?
				tmp_file_path = Rails.root.join("tmp", project.top_image.blob.filename.to_s)
				File.open(tmp_file_path, "wb") do |file|
					file.write open(project.top_image.service_url).read
				end
				scanning_project.top_image.attach(io: File.open(tmp_file_path), filename: project.top_image.blob.filename.to_s)
			end
			if project.bottom_image.attached?
				tmp_file_path = Rails.root.join("tmp", project.bottom_image.blob.filename.to_s)
				File.open(tmp_file_path, "wb") do |file|
					file.write open(project.bottom_image.service_url).read
				end
				scanning_project.bottom_image.attach(io: File.open(tmp_file_path), filename: project.bottom_image.blob.filename.to_s)
			end

			scanning_project.update_attributes(status: scanning_project.calculate_status)
		end
	end

	desc 'Moves Projects with type Modeling to Modeling Project Table'
	task :modeling_projects => :environment do
		puts "Beginning Port Process"

		Project.where(project_type: 'modeling').each do |project|
			puts "Porting #{project.slug}"

			modeling_project = ModelingProject.create!(
				user_id: project.user_id,
				cart_id: project.cart_id,
				order_id: project.order_id,
				workspace_id: project.workspace_id,
				slug: project.slug,
				name: project.name,
				status: project.status,
				paid: project.paid,
				paid_at: project.paid_at,
				final_price: project.final_price,
				description: project.description,
				user_captioned: project.user_captioned,
				user_reviewed: project.user_reviewed,
				womp_reviewed: project.womp_reviewed,
				pricing_group: project.pricing_group,
				price_override: project.price_override,
				modeler_password: project.modeler_password,
				modeler_deadline: project.modeler_deadline,
				created_at: project.created_at,
				previous_project_slug: project.previous_version_project.present? ? project.previous_version_project.slug : nil
			)

			project.comments.each do |comment|
				comment.update_attributes(projectable_id: modeling_project.id, projectable_type: "ModelingProject")
			end
			project.uploads.each do |upload|
				upload.update_attributes(projectable_id: modeling_project.id, projectable_type: "ModelingProject")
			end

			modeling_project.update_attributes(status: modeling_project.calculate_status)
		end

		ModelingProject.where.not(previous_project_slug: nil).each do |modeling_project|
			modeling_project.update_attributes(previous_version_modeling_project_id: ModelingProject.find_by(slug: modeling_project.previous_project_slug).id)
		end
	end
end
