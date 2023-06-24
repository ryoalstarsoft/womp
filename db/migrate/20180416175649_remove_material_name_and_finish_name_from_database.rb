class RemoveMaterialNameAndFinishNameFromDatabase < ActiveRecord::Migration[5.1]
  def change
		remove_column :quotes, :material_name, :string
		remove_column :quotes, :material_identifier, :string
		remove_column :quotes, :finish_name, :string
		remove_column :quotes, :finish_identifier, :string

		remove_column :projects, :material_name, :string
		remove_column :projects, :material_identifier, :string
		remove_column :projects, :finish_name, :string
		remove_column :projects, :finish_identifier, :string
  end
end
