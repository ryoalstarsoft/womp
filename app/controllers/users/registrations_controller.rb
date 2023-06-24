class Users::RegistrationsController < Devise::RegistrationsController
  def new
    @title = "Womp 3D Services - Sign Up"

    super
  end

  protected
	def update_resource(resource, params)
		resource.update_without_password(params)
	end
end
