class AddUserReviewFieldsToProjects < ActiveRecord::Migration[5.2]
  def change
    add_column :projects, :user_captioned, :boolean, default: false
    add_column :projects, :user_reviewed, :boolean, default: false
  end
end
