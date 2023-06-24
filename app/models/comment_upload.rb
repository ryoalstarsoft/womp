class CommentUpload < ApplicationRecord
	belongs_to :comment
	belongs_to :upload
end
