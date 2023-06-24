class AddQuantityToPrintingProjects < ActiveRecord::Migration[5.2]
  def change
    add_column :printing_projects, :quantity, :integer, default: 1
  end
end
