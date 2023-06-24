class AddSmoothingToUploads < ActiveRecord::Migration[5.2]
  def change
    add_column :uploads, :smoothing, :boolean, default: true
  end
end
