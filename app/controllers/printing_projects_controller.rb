class PrintingProjectsController < ApplicationController
	before_action :set_printing_project, only: [:show, :update, :destroy, :increment_quantity, :decrement_quantity]

	def create
		@printing_project = PrintingProject.new(printing_project_params)

		if @printing_project.save
			redirect_to printing_project_path(@printing_project)
		else
			redirect_to new_project_path, alert: 'something went wrong'
		end
	end

	def update
		if @printing_project.update_attributes(printing_project_params)
			@printing_project.update_attributes(name: "printing ##{@printing_project.slug}") if !@printing_project.name.present?
			@printing_project.create_uploads(current_user) # converts temp_uploads to upload model
			@printing_project.send_emails unless printing_project_params[:cart_id] == ""
			@printing_project.uploads.destroy_all if printing_project_params[:delete_last_upload].present? && printing_project_params[:delete_last_upload] == "true"

			if (printing_project_params[:cart_id].present? || printing_project_params[:cart_id] == "") && printing_project_params.keys.count == 1 # only updating the cart
				redirect_to cart_path
			else
				redirect_to printing_project_path(@printing_project)
			end
		else
			flash[:alert] = @printing_project.errors.full_messages.to_sentence.downcase
			render action: :show
		end
	end

	def destroy
		@printing_project.destroy
		redirect_to dashboard_path
	end

	def show
		redirect_to printing_project_path(@printing_project) if params[:slug].to_i - 100000 < 0
		@printing_project.comments.update_all(viewed: true)

		if @printing_project.create_project_complete?
			params[:q] = params[:q].present? ? params[:q].reject{|_,v| v.blank?} : nil

			@q = Material.ransack(params[:q])

			if params[:show_non_printable_materials].present? && params[:show_non_printable_materials] == "true"
				@materials = @q.result.where.not(archived: true).where.not(name: "name")
			else
				@material_ids = @q.result.where.not(archived: true).where.not(name: "name").select{|material| material.within_min_constraints(@printing_project.uploads.last.bounding_box_x, @printing_project.uploads.last.bounding_box_y, @printing_project.uploads.last.bounding_box_z) && material.within_max_constraints(@printing_project.uploads.last.bounding_box_x, @printing_project.uploads.last.bounding_box_y, @printing_project.uploads.last.bounding_box_z)}.map{|material| material.id}
				@materials = Material.where(id: @material_ids)
			end

			@colors = Material.where.not(archived: true).where.not(name: "name").colors
		end

		respond_to do |format|
			format.html
			format.js
		end
	end

	def increment_quantity
		@printing_project.update_attributes(quantity: @printing_project.quantity + 1)

		redirect_back fallback_location: printing_project_path(@printing_project)
	end

	def decrement_quantity
		if @printing_project.quantity == 1
			@printing_project.update_attributes(cart_id: nil)
		else
			@printing_project.update_attributes(quantity: @printing_project.quantity - 1)
		end

		redirect_back fallback_location: printing_project_path(@printing_project)
	end

	private
	def set_printing_project
		@printing_project = current_user.printing_projects.find_by(slug: params[:slug]) || current_user.printing_projects.find(params[:slug])
	end

	def printing_project_params
		params.require(:printing_project).permit(
			:user_id,
			:name,
			:material_id,
			:cart_id,
			:delete_last_upload,
			:temp_uploads,
			temp_uploads: []
		)
	end
end
