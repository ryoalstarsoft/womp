class Material < ApplicationRecord
	has_many :printing_projects
	has_many :quotes

	def display_name
		"#{material_category} - #{finish} - #{name.downcase}"
	end

	def within_min_constraints(x, y, z)
		# X + Y + Z >= 7.5
		seven_point_five_identifiers = [73.0]

		# X + Y + Z >= 10
		ten_identifiers = [140.0, 141.0, 142.0, 143.0]

		# X + Y + Z >= 12
		twelve_identifiers = [77.0, 78.0]

		# X + Y + Z >= 25
		twenty_five_identifiers = [55.0, 56.0, 57.0, 58.0, 59.0, 60.0, 61.0, 62.0, 63.0, 64.0, 65.0, 66.0, 67.0, 68.0, 69.0, 70.0, 71.0, 72.0]

		# X + Y + Z >= 30
		thirty_identifiers = [80.0]

		if seven_point_five_identifiers.include?(self.spreadsheet_identifier) && x.present? && y.present? && z.present?
			(x + y + z) >= 7.5
		elsif ten_identifiers.include?(self.spreadsheet_identifier) && x.present? && y.present? && z.present?
			(x + y + z) >= 10
		elsif twelve_identifiers.include?(self.spreadsheet_identifier) && x.present? && y.present? && z.present?
			(x >= 2.5) && (y >= 2.5) && (z >= 2.5) && (x + y + z) >= 12
		elsif twenty_five_identifiers.include?(self.spreadsheet_identifier) && x.present? && y.present? && z.present?
			(x >= 2.5) && (y >= 2.5) && (z >= 2.5) && (x + y + z) >= 25
		elsif thirty_identifiers.include?(self.spreadsheet_identifier) && x.present? && y.present? && z.present?
			(x + y + z) >= 30
		elsif min_x.present? && min_y.present? && min_z.present? && x.present? && y.present? && z.present?
			(min_x <= x) && (min_y <= y) && (min_z <= z)
		else
			false
		end
	end

	def within_max_constraints(x, y, z)
		if max_x.present? && max_y.present? && max_z.present?
			(max_x >= x) && (max_y >= y) && (max_z >= z)
		else
			false
		end
	end

	def resolution_sort
		hash = { "low": 0, "medium low": 1, "medium": 2, "medium high": 3, "high": 4, "extra high": 5 }

		hash[:"#{resolution}"].present? ? hash[:"#{resolution}"] : 0
	end

	def texture_sort
		hash = { "uneven": 0, "semi-smooth": 1, "smooth": 2, "smoother": 3 }

		hash[:"#{texture}"].present? ? hash[:"#{texture}"] : 0
	end

	def finish_sort
		hash = { "flat": 0, "matte": 1, "satin": 2, "coated": 3, "semi-gloss": 4, "gloss": 5, "unpolished": 6, "polished": 7, "hd polished": 8, "brushed": 9, "blackened": 10 }

		hash[:"#{finish}"].present? ? hash[:"#{finish}"] : 0
	end

	def technology_sort
		hash = { "fdm": 0, "polyjet": 1, "material jetting": 2 , "sla": 3, "sls": 4, "dmls": 5, "binder jet": 6, "casted": 7, "cpg": 8 }

		hash[:"#{technology}"].present? ? hash[:"#{technology}"] : 0
	end

	def self.material_types
		return_material_types = []

		all.each do |material|
			material.material_type.each do |material_type|
				return_material_types.push(material_type)
			end
		end

		return return_material_types.uniq
	end

	def self.custom_group_by_finish(material_type)
		if material_type == "resin"
			all.group_by(&:resin_finish)
		else
			all.group_by(&:finish)
		end
	end

	def self.colors
		colors = []
		all.each do |material|
			material.color.each do |color|
				colors.push(color)
			end
		end

		return colors.uniq
	end

	def self.uses
		uses = []
		all.each do |material|
			material.uses.each do |use|
				uses.push(use)
			end
		end

		return uses.uniq
	end

	# this is to make all the images in flexbox the same width no matter how many attributes they have on the materials page
	def ghost_material_info_wrapper_count
		count = 0

		count += 1 if self.chemical_resistant == true
		count += 1 if self.dishwasher_safe == true
		count += 1 if self.food_safe == false || self.food_safe == true
		count += 1 if self.heat_proof != nil
		count += 1 if self.interlocking == true
		count += 1 if self.skin_friendly == true
		count += 1 if self.water_tight == false || self.water_tight == true

		if count == 2 || count == 3
			4 # return value determines how many ghost divs to show
		elsif count == 4 || count == 5
			2 # return value determines how many ghost divs to show
		else
			0 # return value determines how many ghost divs to show
		end
	end
end
