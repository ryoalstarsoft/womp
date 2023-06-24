class AddPolymorphicFieldsToComments < ActiveRecord::Migration[5.2]
  def change
    add_column :comments, :projectable_id, :integer
    add_column :comments, :projectable_type, :string
  end
end
