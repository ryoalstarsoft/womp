class AddWorkspaceIdToProjects < ActiveRecord::Migration[5.1]
  def change
    add_column :projects, :workspace_id, :integer
  end
end
