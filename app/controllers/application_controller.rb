class ApplicationController < ActionController::Base
  # protect_from_forgery with: :exception
  protect_from_forgery with: :null_session

  protected

  def after_sign_in_path_for(resource)
    sign_in_url = new_admin_session_url
    return admin_dashboard_index_path if request.referrer == sign_in_url
    user_settings_path
  end
end
