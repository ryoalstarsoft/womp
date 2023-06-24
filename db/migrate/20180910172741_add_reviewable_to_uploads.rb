class AddReviewableToUploads < ActiveRecord::Migration[5.2]
  def change
    add_column :uploads, :reviewable, :boolean, default: false
  end
end
