class RemoveCommentIdFromUploads < ActiveRecord::Migration[5.2]
  def change
		remove_column :uploads, :comment_id, :integer
  end
end
