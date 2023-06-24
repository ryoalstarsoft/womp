class AddUserFieldsToUploads < ActiveRecord::Migration[5.1]
  def change
    add_column :uploads, :user_id, :integer
    add_column :uploads, :admin_user_id, :integer
  end
end
