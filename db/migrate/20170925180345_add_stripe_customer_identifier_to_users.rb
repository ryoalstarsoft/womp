class AddStripeCustomerIdentifierToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :stripe_customer_identifier, :string
  end
end
