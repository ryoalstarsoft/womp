class AddModelerDeadlineToProjects < ActiveRecord::Migration[5.2]
  def change
    add_column :projects, :modeler_deadline, :datetime
  end
end
