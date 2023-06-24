class AddPickupInsteadToProjects < ActiveRecord::Migration[5.2]
  def change
    add_column :projects, :picked_up, :boolean, default: false
  end
end
