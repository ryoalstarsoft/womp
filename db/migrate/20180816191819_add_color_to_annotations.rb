class AddColorToAnnotations < ActiveRecord::Migration[5.2]
  def change
    add_column :annotations, :color, :string
  end
end
