class AddWompReceivedToProjects < ActiveRecord::Migration[5.1]
  def change
    add_column :projects, :womp_received, :boolean, default: false
  end
end
