class AddDeniedFieldsToProjects < ActiveRecord::Migration[5.1]
  def change
    add_column :projects, :denied, :boolean, default: false
    add_column :projects, :denied_reason, :text
  end
end
