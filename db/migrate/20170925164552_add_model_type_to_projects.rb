class AddModelTypeToProjects < ActiveRecord::Migration[5.1]
  def change
    add_column :projects, :model_type, :string
		add_column :projects, :womp_reviewed, :boolean, default: false
  end
end
