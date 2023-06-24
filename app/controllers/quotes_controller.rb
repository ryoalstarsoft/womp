class QuotesController < ApplicationController
	skip_before_action :authenticate_user!
	# skip_before_action :check_if_beta_approved, only: :viewer_from_quote
	before_action :set_quote, only: [:show, :update]
	before_action :set_title

	def new
	end

	def show
		if @quote.quote_type == "printing" && @quote.object_height.present? && @quote.object_width.present? && @quote.object_depth.present?
			params[:q] = params[:q].present? ? params[:q].reject{|_, v| v.blank?} : nil

			# There's old links to materials somewhere on the internet with a color_cont filter applied that needs to be removed
			if params[:q].present? && params[:q][:color_cont].present?
				params[:q].delete(:color_cont)
			end

			@q = Material.ransack(params[:q])

			if params[:show_non_printable_materials].present? && params[:show_non_printable_materials] == "true"
				@materials = @q.result.where.not(archived: true).where.not(name: "name")
				@colors = Material.where.not(archived: true).where.not(name: "name").colors
			else
				@material_ids = @q.result.where.not(archived: true).where.not(name: "name").select{|material| material.within_min_constraints(@quote.object_width, @quote.object_depth, @quote.object_height) && material.within_max_constraints(@quote.object_width, @quote.object_depth, @quote.object_height)}.map{|material| material.id}
				@materials = Material.where(id: @material_ids)
				@colors = Material.where(id: @material_ids).where.not(archived: true).where.not(name: "name").colors
			end
		end

		respond_to do |format|
			format.html
			format.js
		end
	end

	def create
		@quote = Quote.new(quote_params)

		if @quote.save
			Quote.find(cookies[:quote_id]).destroy if cookies[:quote_id].present?
			cookies[:quote_id] = @quote.id

			redirect_to quote_path(@quote)
		else
			render action: 'new'
		end
	end

	def update
		if @quote.update_attributes(quote_params)
			redirect_to quote_path(@quote)
		else
			render action: 'show'
		end
	end

	def viewer_from_quote
		@quote = Quote.find(params[:quote_id])

		render 'quotes/printing/viewer_from_quote.json.jbuilder'
	end

	private
	def set_quote
		@quote = Quote.find(cookies[:quote_id])
	end

	def set_title
		@title = "Womp 3D Services - Pricing Quiz"
	end

	def quote_params
		params.require(:quote).permit(
			:quote_type,
			:object_size, # scanning
			:model_type, # modeling
			:object_most_like, # printing
			:hollow_or_solid, # printing
			:wall_thickness, # printing
			:material_id, # printing
			:object_height, # printing
			:object_width, # printing
			:object_depth, # printing
			:printing_price # printing
		)
	end
end
