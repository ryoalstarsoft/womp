class AddQuantityToProjects < ActiveRecord::Migration[5.1]
  def change
    add_column :projects, :quantity, :integer, default: 1
  end
end
