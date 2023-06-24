class Workspace < ApplicationRecord
	has_many :scanning_projects
	has_many :modeling_projects
	has_many :printing_projects

	validates_presence_of :name
end
