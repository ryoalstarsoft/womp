class AddNxsLinkToUploads < ActiveRecord::Migration[5.2]
  def change
    add_column :uploads, :nxs_link, :string
  end
end
