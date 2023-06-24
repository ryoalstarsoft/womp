class Project < ApplicationRecord
	# This class only exists so if a user hits /projects/:slug we can redirect to the correct url (i.e. /modeling_projects/slug)
	belongs_to :user

	def to_param
		slug
	end
end
