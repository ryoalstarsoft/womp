class AddPrintingPriceToProjects < ActiveRecord::Migration[5.1]
  def change
    add_column :projects, :printing_price, :decimal
  end
end
