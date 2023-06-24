class CreateQuotes < ActiveRecord::Migration[5.1]
  def change
    create_table :quotes do |t|
      t.string :quote_type
      t.string :object_size
      t.string :model_type
      t.string :material_name
      t.string :material_identifier
      t.string :finish_name
      t.string :finish_identifier
      t.decimal :object_height
      t.decimal :object_width
      t.decimal :object_depth

      t.timestamps
    end
  end
end
