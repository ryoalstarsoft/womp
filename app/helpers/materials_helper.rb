module MaterialsHelper
	def finish_group_class(category_group, material_type_group, finish_group)
		"#{category_group.first}-#{material_type_group.first.gsub(" ", "-")}-#{finish_group.first.gsub(" ", "-")}"
	end

	def dollar_signs(cost_level)
		if cost_level == 1
			"$<span class='gray-text'>$$$</span>".html_safe
		elsif cost_level == 2
			"$$<span class='gray-text'>$$</span>".html_safe
		elsif cost_level == 3
			"$$$<span class='gray-text'>$</span>".html_safe
		elsif cost_level == 4
			"$$$$"
		end
	end

	def filters_text(parameters)
		parameters.keys.map { |key|
			if parameters["#{key}"].kind_of?(Array)
				if key == "days_to_print_lteq_any"
					parameters["#{key}"].map{ |attribute| "prints in &le; #{attribute} days" }.join(" + ")
				elsif key == "cost_level_eq_any"
					parameters["#{key}"].map{ |attribute| "$" * attribute.to_i }.join(" + ")
				elsif key == "min_wall_supported_lteq_any"
					parameters["#{key}"].map{ |attribute| "min wall thickness &le; #{attribute}" }.join(" + ")
				elsif key == "min_detail_convex_lteq_any"
					parameters["#{key}"].map{ |attribute| "min detail &le; #{attribute}" }.join(" + ")
				else
					parameters["#{key}"].map{ |attribute| attribute }.join(" + ")
				end
			elsif key == "min_x_or_min_y_or_min_z_gteq"
				"min size #{parameters["#{key}"]}mm"
			elsif key == "max_x_or_max_y_or_max_z_lteq"
				"max size #{parameters["#{key}"]}mm"
			elsif key == "comments_viewed_eq"
				"new comments"
			elsif key == "status" || key == "project_status"
				parameters["#{key}"]
			elsif key == "name_cont" || key == "file_blob_filename_cont"
				"name: " + parameters["#{key}"]
			elsif key == "file_type"
				"file type: " + parameters["#{key}"]
			else
				unfrozen_string = "#{key}" # can't manipulate frozen strings like keys
				"#{unfrozen_string.gsub("_present", "").gsub("_eq", "").split("_").join(" ")}"
			end
		}.join(" + ")
	end
end
