class CreateScanningProjects < ActiveRecord::Migration[5.2]
  def change
    create_table :scanning_projects do |t|
      # Associations
      t.integer :user_id
      t.integer :cart_id
      t.integer :order_id
      t.integer :workspace_id

      # Project Basics
      t.string :slug
      t.string :name
      t.string :status
      t.boolean :paid, default: false
      t.datetime :paid_at
      t.decimal :final_price

      # Scanning Essentials
      t.string :object_size
      t.string :resolution
      t.string :color
      t.decimal :length
      t.decimal :width
      t.decimal :height

      # Scanning Process
      t.boolean :user_reviewed, default: false
      t.decimal :price_override
      t.boolean :womp_received, default: false
      t.datetime :received_at
      t.string :tracking_number
      t.string :carrier
      t.boolean :picked_up, default: false

      t.timestamps
    end
  end
end
