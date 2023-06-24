class AddCanceledToProjects < ActiveRecord::Migration[5.1]
  def change
    add_column :projects, :canceled, :boolean, default: false
  end
end
