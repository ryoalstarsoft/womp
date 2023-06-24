class RemoveOldFieldsFromProjects < ActiveRecord::Migration[5.2]
  def change
    remove_column :projects, :name, :string
    remove_column :projects, :description, :text
    remove_column :projects, :object_size, :string
    remove_column :projects, :model_type, :string
    remove_column :projects, :womp_reviewed, :string
    remove_column :projects, :paid, :boolean, default: :false
    remove_column :projects, :pricing_group, :string
    remove_column :projects, :price_override, :decimal
    remove_column :projects, :womp_received, :boolean, default: :false
    remove_column :projects, :denied, :boolean, default: :false
    remove_column :projects, :denied_reason, :text
    remove_column :projects, :tracking_number, :string
    remove_column :projects, :carrier, :string
    remove_column :projects, :canceled, :boolean, default: :false
    remove_column :projects, :cart_id, :integer
    remove_column :projects, :order_id, :integer
    remove_column :projects, :final_price, :decimal
    remove_column :projects, :final_tax, :decimal
    remove_column :projects, :received_at, :datetime
    remove_column :projects, :paid_at, :datetime
    remove_column :projects, :material_id, :integer
    remove_column :projects, :printing_price, :decimal
    remove_column :projects, :quantity, :integer, default: 1
    remove_column :projects, :workspace_id, :integer
    remove_column :projects, :user_captioned, :boolean, default: false
    remove_column :projects, :user_reviewed, :boolean, default: :false
    remove_column :projects, :previous_version_project_id, :integer
    remove_column :projects, :modeler_password, :string
    remove_column :projects, :resolution, :string
    remove_column :projects, :color, :string
    remove_column :projects, :length, :decimal
    remove_column :projects, :width, :decimal
    remove_column :projects, :height, :decimal
    remove_column :projects, :picked_up, :boolean, default: :false
    remove_column :projects, :modeler_deadline, :datetime
    remove_column :projects, :status, :string
  end
end
