class ErrorsController < ApplicationController
	def page_not_found
		render(:status => 404)
	end

	def something_went_wrong
		render(:status => 500)
	end

	def throw_error
		raise Exception.new('something bad happened!')
	end
end
