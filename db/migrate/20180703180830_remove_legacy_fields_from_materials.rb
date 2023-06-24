class RemoveLegacyFieldsFromMaterials < ActiveRecord::Migration[5.1]
  def change
		remove_column :materials, :days_to_ship, :integer, default: 5
		remove_column :materials, :min_wall_thickness, :integer
		remove_column :materials, :base_price, :decimal, default: 0.0
		remove_column :materials, :color, :string
		remove_column :materials, :material_type_id, :integer
  end
end
