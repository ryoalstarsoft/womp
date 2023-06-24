class AddDatabaseIndexesOctober2018 < ActiveRecord::Migration[5.2]
  def change
    add_index :annotations, :upload_id
    add_index :authentications, :user_id
    add_index :carts, :user_id
    add_index :comment_uploads, :comment_id
    add_index :comment_uploads, :upload_id
    add_index :comments, :user_id
    add_index :comments, :admin_user_id
    add_index :comments, :project_id
    add_index :orders, :user_id
    add_index :projects, :user_id
    add_index :projects, :cart_id
    add_index :projects, :order_id
    add_index :projects, :material_id
    add_index :projects, :workspace_id
    add_index :projects, :previous_version_project_id
    add_index :quotes, :material_id
    add_index :uploads, :project_id
    add_index :uploads, :user_id
    add_index :uploads, :admin_user_id
  end
end
