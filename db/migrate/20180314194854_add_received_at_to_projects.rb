class AddReceivedAtToProjects < ActiveRecord::Migration[5.1]
  def change
    add_column :projects, :received_at, :datetime
  end
end
