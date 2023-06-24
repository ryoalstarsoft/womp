class AddPolymorphicFieldsToUploads < ActiveRecord::Migration[5.2]
  def change
    add_column :uploads, :projectable_id, :integer
    add_column :uploads, :projectable_type, :string
  end
end
