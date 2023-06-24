class Users::SessionsController < Devise::SessionsController
  def new
    @title = "Womp 3D Services - Sign In"

    super
  end
end
