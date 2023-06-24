class AddReceiveEmailsToAdminUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :admin_users, :receive_emails, :boolean, default: true
  end
end
