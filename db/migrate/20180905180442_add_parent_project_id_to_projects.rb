class AddParentProjectIdToProjects < ActiveRecord::Migration[5.2]
  def change
    add_column :projects, :previous_version_project_id, :integer
  end
end
