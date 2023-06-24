class AddTrackingNumberAndCarrierToProjects < ActiveRecord::Migration[5.1]
  def change
    add_column :projects, :tracking_number, :string
    add_column :projects, :carrier, :string
  end
end
