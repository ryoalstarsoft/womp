class AddPricingFieldsToProjects < ActiveRecord::Migration[5.1]
  def change
    add_column :projects, :pricing_group, :string
    add_column :projects, :price_override, :decimal
  end
end
