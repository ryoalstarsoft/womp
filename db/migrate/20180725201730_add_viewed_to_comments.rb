class AddViewedToComments < ActiveRecord::Migration[5.2]
  def change
    add_column :comments, :viewed, :boolean, default: false
  end
end
