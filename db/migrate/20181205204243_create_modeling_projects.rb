class CreateModelingProjects < ActiveRecord::Migration[5.2]
  def change
    create_table :modeling_projects do |t|
      # Associations
      t.integer :user_id
      t.integer :cart_id
      t.integer :order_id
      t.integer :workspace_id

      # Project Basics
      t.string :name
      t.string :slug
      t.string :status
      t.boolean :paid, default: false
      t.datetime :paid_at
      t.decimal :final_price

      # Modeling Essentials
      t.text :description
      t.boolean :user_captioned, default: false
      t.boolean :user_reviewed, default: false
      t.boolean :womp_reviewed, default: false
      t.string :pricing_group
      t.decimal :price_override
      t.integer :previous_version_modeling_project_id
      t.string :modeler_password
      t.datetime :modeler_deadline

      t.timestamps
    end
  end
end
