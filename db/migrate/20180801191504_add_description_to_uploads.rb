class AddDescriptionToUploads < ActiveRecord::Migration[5.2]
  def change
    add_column :uploads, :description, :text
  end
end
