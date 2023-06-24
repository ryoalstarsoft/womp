class AddModelerPasswordToProjects < ActiveRecord::Migration[5.2]
  def change
    add_column :projects, :modeler_password, :string
  end
end
