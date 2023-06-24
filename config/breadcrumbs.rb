crumb :root do
  link "home", admin_root_path
end

# Projects
crumb :projects do
  link "projects", admin_projects_path
  parent :root
end

crumb :project do |project|
	if project.class.name == "ScanningProject"
		link = admin_scanning_project_path(project)
	elsif project.class.name == "ModelingProject"
		link = admin_modeling_project_path(project)
	elsif project.class.name == "PrintingProject"
		link = admin_printing_project_path(project)
	end

  link "#{project.name.present? ? project.name : 'not named yet'}", link
  parent :projects
end

crumb :edit_project do |project|
	if project.class.name == "ScanningProject"
		link = edit_admin_scanning_project_path(project)
	elsif project.class.name == "ModelingProject"
		link = edit_admin_modeling_project_path(project)
	elsif project.class.name == "PrintingProject"
		link = edit_admin_printing_project_path(project)
	end

  link "edit", link
  parent :project, project
end

crumb :annotate_upload do |upload|
  link "annotate #{upload.file.blob.filename}", annotate_admin_upload_path(upload)
  parent :project, upload.project
end

# Workspaces
crumb :workspaces do
  link "workspaces", admin_workspaces_path
  parent :root
end

crumb :new_workspace do
  link "new", new_admin_workspace_path
  parent :workspaces
end

crumb :workspace do |workspace|
  link "#{workspace.name}", admin_workspace_path(workspace)
  parent :workspaces
end

crumb :edit_workspace do |workspace|
  link "edit", edit_admin_workspace_path(workspace)
  parent :workspace, workspace
end

# Materials
crumb :materials do
  link "materials", admin_materials_path
  parent :root
end

crumb :new_material do
  link "new", new_admin_material_path
  parent :materials
end

crumb :material do |material|
  link "#{material.display_name}", admin_material_path(material)
  parent :materials
end

crumb :edit_material do |material|
  link "edit", edit_admin_material_path(material)
  parent :material, material
end

# Admin Users
crumb :admin_users do
  link "admin users", admin_admin_users_path
  parent :root
end

crumb :new_admin_user do
  link "new", new_admin_admin_user_path
  parent :admin_users
end

crumb :admin_user do |admin_user|
  link "#{admin_user.email}", admin_admin_user_path(admin_user)
  parent :admin_users
end

crumb :edit_admin_user do |admin_user|
  link "edit", edit_admin_admin_user_path(admin_user)
  parent :admin_user, admin_user
end

# Users
crumb :users do
  link "users", admin_users_path
  parent :root
end

crumb :user do |user|
  link "#{user.email}", admin_user_path(user)
  parent :users
end
