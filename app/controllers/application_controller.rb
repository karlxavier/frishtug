class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  protected

  def after_sign_in_path_for(resource)
    sign_in_url = new_admin_session_url
    return admin_dashboard_index_path if request.referrer == sign_in_url
    user_dashboard_index_path
  end
end
