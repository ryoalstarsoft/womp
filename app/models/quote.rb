class Quote < ApplicationRecord
	belongs_to :material, optional: true

	def printing_size_complete?
		object_height.present? && object_width.present? && object_depth.present?
	end

	def minimum_dimension
		dimensions = [object_height, object_width, object_depth]

		return dimensions.sort.last
	end

	def max_wall_thickness
		minimum_dimension.to_f / 2.0
	end

	def total_price
		if quote_type == "scanning"
			if object_size == "one_inch_to_six_inches"
				"$150 - $300"
			elsif object_size == "seven_inches_to_twenty_four_inches"
				"$150 - $400"
			elsif object_size == "twenty_five_inches_to_thirty_two_inches"
				"$250 - $600"
			elsif object_size == "thirty_three_inches_to_fifty_six_inches"
				"$300 - $800"
			elsif object_size == "other"
				nil
			else
				nil
			end
		elsif quote_type == "modeling"
			if model_type == "sharp_transitions"
				40
			elsif model_type == "engraving_and_extrusion"
				20
			elsif model_type == "replica"
				250
			elsif model_type == "organic_shapes"
				200
			elsif model_type == "soft_transitions"
				100
			elsif model_type == "jewelry"
				200
			elsif model_type == "architectural"
				200
			elsif model_type == "file_fixing"
				250
			elsif model_type == "parametric"
				250
			elsif model_type == "extreme_precision"
				500
			elsif model_type == "other"
				250
			else
				250
			end
		elsif quote_type == "printing"
			price_from_material(self.material)
		else
			nil
		end
	end

	def volume
		if object_most_like == "cube"
			(object_height * object_width * object_depth).round(2)
		elsif object_most_like == "sphere"
			# http://www.web-formulas.com/Math_Formulas/Geometry_Volume_of_Ellipsoid.aspx
			a = object_width.to_f / 2.0
			b = object_height.to_f / 2.0
			c = object_depth.to_f / 2.0

			((4.0/3.0) * Math::PI * a * b * c).round(2)
		elsif object_most_like == "cone"
			# http://www.web-formulas.com/Math_Formulas/Geometry_Volume_of_Cone.aspx
			# ** is for exponents
			r = object_width.to_f / 2.0
			h = object_height.to_f

			(Math::PI * (r**2.0) * (h/3.0)).round(2)
		end
	end

	def bounding_box_volume
		(object_height * object_width * object_depth).round(2)
	end

	def surface_area
		if object_most_like == "cube"
			(2.0 * (object_width * object_height)) +
			(2.0 * (object_width * object_depth)) +
			(2.0 * (object_depth * object_height))
		elsif object_most_like == "sphere"
			# http://www.web-formulas.com/Math_Formulas/Geometry_Surface_of_Ellipsoid.aspx
			# ** is for exponents
			a = object_width.to_f / 2.0
			b = object_height.to_f / 2.0
			c = object_depth.to_f / 2.0

			(4.0 * Math::PI * (((a*b)**1.6075 + (a*c)**1.6075 + (b*c)**1.6075)/3.0)**(1.0/1.6075)).round(2)
		elsif object_most_like == "cone"
			# http://www.web-formulas.com/Math_Formulas/Geometry_Surface_of_Cone.aspx
			r = object_width.to_f / 2.0
			h = object_height.to_f

			(Math::PI * r * (r + Math.sqrt(h**2 + r**2))).round(2)
		end
	end

	def price_from_material(material)
		# note: all prices are in cm^3 so must do some conversions
		price = 0

		steel_ids = [141, 142, 143, 144, 145, 146, 147, 148]

		if steel_ids.include?(material.id) && (bounding_box_volume / 1000) >= 1000
			price += 7.0 # base price
			price += 0.30 * (bounding_box_volume / 1000) # divide by 1000 to convert to cm^3)
			price += 0.80 * (volume / 1000) # divide by 1000 to convert to cm^3)
		else
			price += material.per_part_price
			price += material.support_price
			price += material.handling_price
			price += (material.surface_area_price * (surface_area / 100)) # divide by 100 to convert to cm^2
			price += (material.volume_price * (volume / 1000)) # divide by 1000 to convert to cm^3)
			price += (material.bounding_box_price * (bounding_box_volume / 1000)) # divide by 1000 to convert to cm^3
		end

		return price * 1.2
	end
end
