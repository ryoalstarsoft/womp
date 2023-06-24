class CreateUploads < ActiveRecord::Migration[5.1]
  def change
    create_table :uploads do |t|
      t.integer :project_id
      t.string :link
      t.string :original_filename

      t.timestamps
    end
  end
end
