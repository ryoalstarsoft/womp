class AddDrcLinkToUploads < ActiveRecord::Migration[5.1]
  def change
    add_column :uploads, :drc_link, :string
  end
end
