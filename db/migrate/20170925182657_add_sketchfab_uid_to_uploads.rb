class AddSketchfabUidToUploads < ActiveRecord::Migration[5.1]
  def change
    add_column :uploads, :sketchfab_uid, :string
  end
end
