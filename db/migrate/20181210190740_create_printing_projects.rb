class CreatePrintingProjects < ActiveRecord::Migration[5.2]
  def change
    create_table :printing_projects do |t|
      # Associations
      t.integer :user_id
      t.integer :cart_id
      t.integer :order_id
      t.integer :workspace_id
      t.integer :material_id

      # Project Basics
      t.string :name
      t.string :slug
			t.string :status
      t.boolean :paid, default: false
      t.datetime :paid_at
      t.decimal :final_price
      t.decimal :final_tax

			# Printing Essentials
			t.boolean :womp_reviewed, default: false
			t.decimal :price_override
      t.string :tracking_number
      t.string :carrier
      t.boolean :picked_up

      t.timestamps
    end
  end
end
