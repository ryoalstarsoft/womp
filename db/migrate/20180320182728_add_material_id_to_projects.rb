class AddMaterialIdToProjects < ActiveRecord::Migration[5.1]
  def change
    add_column :projects, :material_id, :integer
  end
end
