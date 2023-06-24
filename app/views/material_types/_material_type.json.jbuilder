json.id material_type.id
json.name material_type.name.downcase
json.materials material_type.materials do |material|
	json.partial! 'materials/material', material: material
end
