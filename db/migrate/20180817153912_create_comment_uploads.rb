class CreateCommentUploads < ActiveRecord::Migration[5.2]
  def change
    create_table :comment_uploads do |t|
      t.integer :comment_id
      t.integer :upload_id

      t.timestamps
    end
  end
end
