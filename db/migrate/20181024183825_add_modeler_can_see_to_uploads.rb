class AddModelerCanSeeToUploads < ActiveRecord::Migration[5.2]
  def change
    add_column :uploads, :modeler_can_see, :boolean, default: false
  end
end
