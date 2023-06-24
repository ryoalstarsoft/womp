class ChangeImaterialiseIdentifierColumn < ActiveRecord::Migration[5.1]
  def change
		change_column :uploads, :imaterialise_id, :string
  end
end
