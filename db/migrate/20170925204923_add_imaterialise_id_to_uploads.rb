class AddImaterialiseIdToUploads < ActiveRecord::Migration[5.1]
  def change
    add_column :uploads, :imaterialise_id, :integer
  end
end
