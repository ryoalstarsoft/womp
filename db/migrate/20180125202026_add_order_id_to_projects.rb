class AddOrderIdToProjects < ActiveRecord::Migration[5.1]
  def change
    add_column :projects, :order_id, :integer
  end
end
