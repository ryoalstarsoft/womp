class AddNewDatabaseIndexes < ActiveRecord::Migration[5.2]
  def change
    add_index :comments, [:projectable_id, :projectable_type]
    add_index :uploads, [:projectable_id, :projectable_type]

    add_index :modeling_projects, :user_id
    add_index :modeling_projects, :cart_id
    add_index :modeling_projects, :order_id
    add_index :modeling_projects, :workspace_id
    add_index :modeling_projects, :previous_version_modeling_project_id

    add_index :printing_projects, :user_id
    add_index :printing_projects, :cart_id
    add_index :printing_projects, :order_id
    add_index :printing_projects, :workspace_id
    add_index :printing_projects, :material_id

    add_index :scanning_projects, :user_id
    add_index :scanning_projects, :cart_id
    add_index :scanning_projects, :order_id
    add_index :scanning_projects, :workspace_id
  end
end
