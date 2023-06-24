class AddFinalPricesToProjects < ActiveRecord::Migration[5.1]
  def change
    add_column :projects, :final_price, :decimal
    add_column :projects, :final_tax, :decimal
  end
end
