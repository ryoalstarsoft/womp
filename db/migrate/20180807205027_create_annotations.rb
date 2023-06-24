class CreateAnnotations < ActiveRecord::Migration[5.2]
  def change
    create_table :annotations do |t|
      t.integer :upload_id
      t.decimal :x
      t.decimal :y
      t.decimal :width
      t.decimal :height
      t.string :annotation_type
      t.text :text

      t.timestamps
    end
  end
end
