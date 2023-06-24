class AddPaidAtToProjects < ActiveRecord::Migration[5.1]
  def change
    add_column :projects, :paid_at, :datetime
  end
end
