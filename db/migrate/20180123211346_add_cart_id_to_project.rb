class AddCartIdToProject < ActiveRecord::Migration[5.1]
  def change
    add_column :projects, :cart_id, :integer
  end
end
