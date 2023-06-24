class AddNewFieldsToMaterials < ActiveRecord::Migration[5.1]
  def change
    add_column :materials, :spreadsheet_identifier, :decimal
    add_column :materials, :material_category, :string
    add_column :materials, :roll_inventory, :integer
    add_column :materials, :material_type, :string
		add_column :materials, :resin_finish, :string
    add_column :materials, :color, :string, array: true, default: []
    add_column :materials, :days_to_print, :integer
    add_column :materials, :cost_level, :integer
    add_column :materials, :material_spec, :string
    add_column :materials, :skin_friendly, :boolean
    add_column :materials, :interlock, :boolean
    add_column :materials, :water_tight, :boolean
    add_column :materials, :chemical_resistant, :boolean
    add_column :materials, :heat_proof, :string
    add_column :materials, :dishwasher_safe, :boolean
    add_column :materials, :food_safe, :boolean
		add_column :materials, :min_size, :string
		add_column :materials, :max_size, :string
    add_column :materials, :min_wall_supported, :decimal
    add_column :materials, :min_wall_unsupported, :decimal
    add_column :materials, :min_wire_supported, :decimal
    add_column :materials, :min_wire_unsupported, :decimal
    add_column :materials, :min_detail_concave, :decimal
    add_column :materials, :min_detail_convex, :decimal
    add_column :materials, :escape_hole_single, :integer
    add_column :materials, :escape_hole_multiple, :integer
    add_column :materials, :clearance, :decimal
    add_column :materials, :per_part_price, :decimal
    add_column :materials, :uses, :string, array: true, default: []
    add_column :materials, :pros, :string, array: true, default: []
    add_column :materials, :cons, :string, array: true, default: []
		add_column :materials, :archived, :boolean, default: false
  end
end
