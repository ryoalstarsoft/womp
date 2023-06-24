class AddAcceptedToUploads < ActiveRecord::Migration[5.1]
  def change
    add_column :uploads, :accepted, :boolean
  end
end
