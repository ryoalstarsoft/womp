class RenameInterlockToInterlocking < ActiveRecord::Migration[5.1]
  def change
		rename_column :materials, :interlock, :interlocking
  end
end
