class Admin::ModelingProjectsController < Admin::AdminController
	before_action :set_modeling_project, only: [:show, :edit, :update, :destroy, :remove_pricing_group, :new_modeling_project_version]

	def show
	end

	def edit
	end

	def update
		if @modeling_project.update_attributes(modeling_project_params)
			if modeling_project_params[:allowed_for_modeler_upload_ids].present?
				@modeling_project.uploads.update_all(modeler_can_see: false)
				modeling_project_params[:allowed_for_modeler_upload_ids].each do |id|
					@modeling_project.uploads.find(id).update_attributes(modeler_can_see: true)
				end
			end

			if modeling_project_params[:mark_project_incomplete].present?
				@modeling_project.uploads.where(accepted: true).each do |upload|
					upload.update_attributes(accepted: nil) # doing this instead of update_all so that the after_update callback is fired
				end
			end

			@modeling_project.create_uploads(current_admin_user, modeling_project_params[:reviewable])
			@modeling_project.send_emails unless modeling_project_params[:workspace_id].present? || modeling_project_params[:modeler_password].present? || modeling_project_params[:allowed_for_modeler_upload_ids].present? || modeling_project_params[:modeler_deadline].present? || modeling_project_params[:mark_project_incomplete].present?

			redirect_to admin_modeling_project_path(@modeling_project)
		else
			flash[:alert] = @modeling_project.errors.full_messages.to_sentence.downcase
			redirect_back fallback_location: admin_modeling_project_path(@modeling_project)
		end
	end

	def new_modeling_project_version
		set_name_and_version

		@new_modeling_project = ModelingProject.create!(
			previous_version_modeling_project_id: @modeling_project.id,
			pricing_group: modeling_project_params[:pricing_group],
			price_override: modeling_project_params[:price_override],
			user_id: @modeling_project.user_id,
			name: "#{@name} v#{@version}",
			description: @modeling_project.description,
			user_captioned: true,
			user_reviewed: true
		)
		@modeling_project.uploads.select{|upload| !upload.comment_uploads.present?}.each do |upload|
			if upload.file.attached?
				tmp_file_path = Rails.root.join("tmp", sanitize_filename(upload.file.blob.filename.to_s)).to_s

				File.open(tmp_file_path, "wb") do |file|
					file.write open(upload.file.blob.service_url(expires_in: 1.week)).read
				end

				new_upload = @new_modeling_project.uploads.create!(
					user_id: upload.user_id,
					admin_user_id: upload.admin_user_id,
					description: upload.description,
	        released_to_user: true,
					created_at: upload.created_at
				)

				new_upload.file.attach(io: File.open(tmp_file_path), filename: sanitize_filename(upload.file.blob.filename.to_s).to_s)
				new_upload.enqueue_calcuations

				FileUtils.rm(tmp_file_path)
			end
		end
		@modeling_project.comments.each do |comment|
			new_comment = Comment.new(
				projectable: @new_modeling_project,
				body: comment.body,
				created_at: comment.created_at
			)

			# This needs to be assigned after the comment object is created due to an obscure AssociationMismatch Rails error
			if comment.admin_user.present?
				new_comment.admin_user_id = comment.admin_user_id
			else
				new_comment.user_id = comment.user_id
			end

			new_comment.save(validate: false) # skip validations because the body may be nil and the uploads haven't been attached yet

			comment.uploads.each do |upload|
				if upload.file.attached?
					tmp_file_path = Rails.root.join("tmp", sanitize_filename(upload.file.blob.filename.to_s)).to_s

					File.open(tmp_file_path, "wb") do |file|
						file.write open(upload.file.blob.service_url(expires_in: 1.week)).read
					end

					new_upload = new_comment.uploads.create!(
						projectable: @new_modeling_project,
						user_id: upload.user_id,
						admin_user_id: upload.admin_user_id,
						description: upload.description,
	          released_to_user: true,
						created_at: upload.created_at
					)

					new_upload.file.attach(io: File.open(tmp_file_path), filename: sanitize_filename(upload.file.blob.filename.to_s).to_s)

					FileUtils.rm(tmp_file_path)
				end
			end
		end

		@new_modeling_project.send_new_version_email
		redirect_to admin_modeling_project_path(@new_modeling_project)
	end

	# Exists to Bypass Sending Email
	def remove_pricing_group
		@modeling_project.update_attributes(pricing_group: nil, price_override: nil)
		redirect_back(fallback_location: admin_modeling_project_path(@modeling_project), notice: "pricing group removed")
	end

	private
	def set_modeling_project
		@modeling_project = ModelingProject.find_by(slug: params[:slug]) || ModelingProject.find(params[:slug])
	end

	def set_name_and_version
		@version = 2
		@stop_iterating = false
		 @version_modeling_project = @modeling_project

		while @stop_iterating == false do
			if @version_modeling_project.previous_version_modeling_project.present?
				@version += 1
				@version_modeling_project = @version_modeling_project.previous_version_modeling_project
			else
				@stop_iterating = true
			end
		end

		if @version > 2
			@name = @modeling_project.name.gsub(/ *v\d+$/, '')
		else
			@name = @modeling_project.name
		end
	end

	def modeling_project_params
		params.require(:modeling_project).permit(
			:workspace_id,
			:pricing_group,
			:price_override,
			:reviewable,
			:mark_project_incomplete,
			:modeler_deadline,
			:modeler_password,
			:temp_uploads,
			:allowed_for_modeler_upload_ids,
			allowed_for_modeler_upload_ids: [],
			temp_uploads: []
		)
	end

	def sanitize_filename(filename)
		fn = filename.split /(?<=.)\.(?=[^.])(?!.*\.[^.])/m
		fn.map! { |s| s.gsub /[^a-z0-9\-]+/i, '_' }

		return fn.join '.'
	end
end
