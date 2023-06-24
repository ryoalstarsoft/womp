class CreateMaterials < ActiveRecord::Migration[5.1]
  def change
    create_table :materials do |t|
      t.integer :material_type_id
      t.string :provider
      t.string :name
      t.integer :days_to_ship, default: 5
      t.string :texture
      t.string :finish
      t.boolean :direct_print
      t.string :resolution
      t.decimal :min_x
      t.decimal :min_y
      t.decimal :min_z
      t.decimal :max_x
      t.decimal :max_y
      t.decimal :max_z
      t.string :technology
      t.decimal :min_wall_thickness
      t.decimal :base_price, default: 0.0
      t.decimal :volume_price, default: 0.0
      t.decimal :machine_space_price, default: 0.0
      t.decimal :bounding_box_price, default: 0.0
      t.decimal :surface_area_price, default: 0.0
      t.decimal :handling_price, default: 0.0
      t.decimal :support_price, default: 0.0
      t.string :color
      t.string :preview_image_url
      t.string :model_image_url

      t.timestamps
    end
  end
end
