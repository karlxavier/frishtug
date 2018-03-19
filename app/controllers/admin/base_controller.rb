class Admin::BaseController < ApplicationController
  layout 'admin_dashboard'
  protect_from_forgery with: :null_session
  before_action :authenticate_admin!
end
