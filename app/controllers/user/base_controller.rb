class User::BaseController < ApplicationController
  protect_from_forgery with: :null_session
  before_action :authenticate_user!, :set_full_name
  layout 'user_dashboard'

  private

  def set_full_name
    session[:full_name] = current_user.full_name || 'guest'
  end
end
