namespace :delete do
	desc 'Deletes old materials...'
	task :old_materials => :environment do
		Project.where(project_type: "printing").where.not(material_id: nil).where(paid: false).update_all(material_id: nil)

		archived_material_ids = [21, 81, 84]
		Material.where.not(id: archived_material_ids).destroy_all

		Material.where(id: archived_material_ids).update_all(archived: true)
	end
end
