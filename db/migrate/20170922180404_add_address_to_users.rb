class AddAddressToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :address_line_one, :string
		add_column :users, :address_line_two, :string
		add_column :users, :city, :string
		add_column :users, :state, :string
		add_column :users, :zip_code, :string
		add_column :users, :country, :string
  end
end
