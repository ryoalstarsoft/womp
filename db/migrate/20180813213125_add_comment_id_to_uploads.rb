class AddCommentIdToUploads < ActiveRecord::Migration[5.2]
  def change
    add_column :uploads, :comment_id, :integer
  end
end
