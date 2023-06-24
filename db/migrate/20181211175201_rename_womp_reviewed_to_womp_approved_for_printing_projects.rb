class RenameWompReviewedToWompApprovedForPrintingProjects < ActiveRecord::Migration[5.2]
  def change
    rename_column :printing_projects, :womp_reviewed, :womp_approved
  end
end
