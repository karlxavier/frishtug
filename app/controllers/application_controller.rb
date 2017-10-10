class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  protected

  def after_sign_in_path_for(_resource)
    sign_in_url = new_admin_session_url
    admin_dashboard_index_path if request.referrer == sign_in_url
  end
end