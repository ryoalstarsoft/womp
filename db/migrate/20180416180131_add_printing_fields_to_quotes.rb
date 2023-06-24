class AddPrintingFieldsToQuotes < ActiveRecord::Migration[5.1]
  def change
    add_column :quotes, :object_most_like, :string
    add_column :quotes, :hollow_or_solid, :string
    add_column :quotes, :wall_thickness, :decimal
    add_column :quotes, :material_id, :integer
  end
end
