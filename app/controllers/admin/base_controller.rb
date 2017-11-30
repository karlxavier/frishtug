class Admin::BaseController < ApplicationController
  layout 'admin_dashboard'
  before_action :authenticate_admin!
end
