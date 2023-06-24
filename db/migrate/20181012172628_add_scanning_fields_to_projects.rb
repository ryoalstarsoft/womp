class AddScanningFieldsToProjects < ActiveRecord::Migration[5.2]
  def change
    add_column :projects, :resolution, :string
    add_column :projects, :color, :string
    add_column :projects, :length, :decimal
    add_column :projects, :width, :decimal
    add_column :projects, :height, :decimal
  end
end
