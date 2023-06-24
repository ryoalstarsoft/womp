class AddFinishNameAndFinishIdentifierToProjects < ActiveRecord::Migration[5.1]
  def change
    add_column :projects, :finish_name, :string
    add_column :projects, :finish_identifier, :string
  end
end
