class AddPrintingPriceToQuotes < ActiveRecord::Migration[5.1]
  def change
    add_column :quotes, :printing_price, :decimal
  end
end
