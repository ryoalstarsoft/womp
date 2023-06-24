class Admin::MaterialsController < Admin::AdminController
  before_action :set_material, only: [:show, :edit, :update]

  def index
    @materials = Material.all
  end

  def show
  end

  def new
  end

  def edit
  end

  def create
    file = params[:materials_report]

		spreadsheet = Roo::Spreadsheet.open(file.path, extension: :xlsx)
		header = spreadsheet.row(1)

		# not doing (2..spreadsheet.last_row) because the last row is in the millions
		(2..200).each do |i|
			column = Hash[[header, spreadsheet.row(i)].transpose]

			if Material.where(spreadsheet_identifier: column["spreadsheet identifier"].to_f).present?
				material = Material.find_by(spreadsheet_identifier: column["spreadsheet identifier"].to_f)

				puts "IDENTIFIER: #{column["spreadsheet identifier"]}"

				material.update_attributes(
					roll_inventory: column["roll inventory"],
					material_category: column["material category"],
					spreadsheet_identifier: column["spreadsheet identifier"].to_f,
					provider: column["provider"],
					material_type: column["material type"],
					name: column["name"],
					color: column["filter color"].split(" & ").map{|color| color.strip == "grey" ? "gray" : color.strip},
					finish: column["finish"],
					resin_finish: column["resin finish"],
					texture: column["texture"],
					days_to_print: column["prints in"].to_i,
					cost_level: column["cost level"].length,
					resolution: column["resolution"].strip,
					technology: column["technology"],
					material_spec: column["material spec"],
					skin_friendly: define_boolean(column["skin friendly"]),
					interlocking: define_boolean(column["interlock"]),
					water_tight: define_boolean(column["water tight"]),
					chemical_resistant: define_boolean(column["chemical resistant"]),
					heat_proof: column["heat proof"],
					dishwasher_safe: define_boolean(column["dishwasher safe"]),
					food_safe: define_boolean(column["food safe"]),
					direct_print: define_boolean(column["direct print"]),
					min_x: define_min(column["min x"]),
					min_y: define_min(column["min y"]),
					min_z: define_min(column["min z"]),
					min_size: column["min size"],
					max_x: column["max x"].to_i,
					max_y: column["max y"].to_i,
					max_z: column["max z"].to_i,
					max_size: column["max size (single print)"],
					min_wall_supported: column["min wall supported"].to_f,
					min_wall_unsupported: column["min wall unsupported"].to_f,
					min_wire_supported: column["min wire supported"].to_f,
					min_wire_unsupported: column["min wire unsupported"].to_f,
					min_detail_concave: column["min detail concave"].to_f,
					min_detail_convex: column["min detail convex"].to_f,
					escape_hole_single: define_escape_hole(column["escape hole single"]),
					escape_hole_multiple: define_escape_hole(column["escape hole multiple"]),
					clearance: column["clearance"],
					per_part_price: column["per part price"].to_f,
					volume_price: column["volume price"].to_f,
					machine_space_price: column["machine space price"].to_f,
					bounding_box_price: column["bounding box price"].to_f,
					surface_area_price: column["surface area price"].to_f,
					handling_price: column["handling price"].to_f,
					support_price: column["support price"].to_f,
					uses: column["uses"].split("*").map{|use| use.strip},
					pros: column["pros"].split("*").map{|pro| pro.strip},
					cons: column["cons"].split("*").map{|con| con.strip},
					preview_image_url: define_preview_image_url(column["spreadsheet identifier"])
				)
			elsif column["spreadsheet identifier"].present?
				Material.create!(
					roll_inventory: column["roll inventory"],
					material_category: column["material category"],
					spreadsheet_identifier: column["spreadsheet identifier"].to_f,
					provider: column["provider"],
					material_type: column["material type"],
					name: column["name"],
					color: column["filter color"].split(" & ").map{|color| color.strip == "grey" ? "gray" : color.strip},
					finish: column["finish"],
					resin_finish: column["resin finish"],
					texture: column["texture"],
					days_to_print: column["prints in"].to_i,
					cost_level: column["cost level"].length,
					resolution: column["resolution"].strip,
					technology: column["technology"],
					material_spec: column["material spec"],
					skin_friendly: define_boolean(column["skin friendly"]),
					interlocking: define_boolean(column["interlock"]),
					water_tight: define_boolean(column["water tight"]),
					chemical_resistant: define_boolean(column["chemical resistant"]),
					heat_proof: column["heat proof"],
					dishwasher_safe: define_boolean(column["dishwasher safe"]),
					food_safe: define_boolean(column["food safe"]),
					direct_print: define_boolean(column["direct print"]),
					min_x: define_min(column["min x"]),
					min_y: define_min(column["min y"]),
					min_z: define_min(column["min z"]),
					min_size: column["min size"],
					max_x: column["max x"].to_i,
					max_y: column["max y"].to_i,
					max_z: column["max z"].to_i,
					max_size: column["max size (single print)"],
					min_wall_supported: column["min wall supported"].to_f,
					min_wall_unsupported: column["min wall unsupported"].to_f,
					min_wire_supported: column["min wire supported"].to_f,
					min_wire_unsupported: column["min wire unsupported"].to_f,
					min_detail_concave: column["min detail concave"].to_f,
					min_detail_convex: column["min detail convex"].to_f,
					escape_hole_single: define_escape_hole(column["escape hole single"]),
					escape_hole_multiple: define_escape_hole(column["escape hole multiple"]),
					clearance: column["clearance"],
					per_part_price: column["per part price"].to_f,
					volume_price: column["volume price"].to_f,
					machine_space_price: column["machine space price"].to_f,
					bounding_box_price: column["bounding box price"].to_f,
					surface_area_price: column["surface area price"].to_f,
					handling_price: column["handling price"].to_f,
					support_price: column["support price"].to_f,
					uses: column["uses"].split("*").map{|use| use.strip},
					pros: column["pros"].split("*").map{|pro| pro.strip},
					cons: column["cons"].split("*").map{|con| con.strip},
					preview_image_url: define_preview_image_url(column["spreadsheet identifier"])
				)
			end
		end

		redirect_to admin_materials_path
  end

  def update
    if @material.update_attributes(material_params)
      redirect_to admin_material_path(@material)
    else
      render action: :edit
    end
  end

  private
  def set_material
    @material = Material.find(params[:id])
  end

  def material_params
    params.require(:material).permit(
      :provider,
      :name,
      :texture,
      :finish,
      :direct_print,
      :resolution,
      :min_x,
      :min_y,
      :min_z,
      :max_x,
      :max_y,
      :max_z,
      :technology,
      :volume_price,
      :machine_space_price,
      :bounding_box_price,
      :surface_area_price,
      :handling_price,
      :support_price,
      :preview_image_url,
      :model_image_url,
      :created_at,
      :updated_at,
      :spreadsheet_identifier,
      :material_category,
      :roll_inventory,
      :material_type,
      :resin_finish,
      :days_to_print,
      :cost_level,
      :material_spec,
      :skin_friendly,
      :interlocking,
      :water_tight,
      :chemical_resistant,
      :heat_proof,
      :dishwasher_safe,
      :food_safe,
      :min_size,
      :max_size,
      :min_wall_supported,
      :min_wall_unsupported,
      :min_wire_supported,
      :min_wire_unsupported,
      :min_detail_concave,
      :min_detail_convex,
      :escape_hole_single,
      :escape_hole_multiple,
      :clearance,
      :per_part_price,
      :archived,
      :uses,
      :pros,
      :cons,
      :color,
      uses: [],
      pros: [],
      cons: [],
      color: []
    )
  end

  def define_boolean(column_value)
		if column_value == "yes"
			true
		elsif column_value == "no"
			false
		else
			nil # the booleans being returned may not be true or false, so we assign them nil
		end
	end

	def define_min(column_value)
		if column_value.to_f == 0.0
			nil # some minimum values aren't hard metrics but are hard coded into the platform, to determine which ones have calculations we assign them a nil min value
		else
			column_value.to_f
		end
	end

	def define_escape_hole(column_value)
		if column_value.to_f == 0.0
			nil # some escape hole values aren't anything
		else
			column_value.to_f
		end
	end

	def define_preview_image_url(column_value)
		base_url = "https://s3.amazonaws.com/womp-platform-live/material-images/"

		if column_value.to_s.include?(".")
			suffix = "#{column_value.to_s.rjust(5, "0")}.png"
		else
			suffix = "#{column_value.to_s.rjust(3, "0")}.png"
		end

		return base_url + suffix
	end
end
