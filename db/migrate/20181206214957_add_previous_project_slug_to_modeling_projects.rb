class AddPreviousProjectSlugToModelingProjects < ActiveRecord::Migration[5.2]
  def change
    add_column :modeling_projects, :previous_project_slug, :string
  end
end
