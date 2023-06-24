class AddReleasedToUserToUploads < ActiveRecord::Migration[5.2]
  def change
    add_column :uploads, :released_to_user, :boolean, default: false
  end
end
