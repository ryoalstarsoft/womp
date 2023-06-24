class AddCalculationFieldsToUploads < ActiveRecord::Migration[5.1]
  def change
    add_column :uploads, :volume, :decimal
    add_column :uploads, :surface_area, :decimal
    add_column :uploads, :bounding_box_volume, :decimal
    add_column :uploads, :bounding_box_x, :decimal
    add_column :uploads, :bounding_box_y, :decimal
    add_column :uploads, :bounding_box_z, :decimal
    add_column :uploads, :machine_space, :decimal
  end
end
