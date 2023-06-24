class CreateProjects < ActiveRecord::Migration[5.1]
  def change
    create_table :projects do |t|
      t.integer :user_id
      t.string :project_type
      t.string :name
      t.text :description
      t.string :object_size
      t.string :material_name
      t.string :material_identifier

      t.timestamps
    end
  end
end
