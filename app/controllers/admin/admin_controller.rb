class Admin::AdminController < ActionController::Base
  layout 'admin'

  protect_from_forgery with: :null_session
  before_action :authenticate_admin_user!
  before_action :prepare_exception_notifier

  private
  def prepare_exception_notifier
    request.env["exception_notifier.exception_data"] = {
      :current_admin_user => (current_admin_user.present? ? current_admin_user.email : 'Not Logged In')
    }
  end
end
