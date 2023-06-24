class AddPaidToProjects < ActiveRecord::Migration[5.1]
  def change
    add_column :projects, :paid, :boolean, default: false
  end
end
