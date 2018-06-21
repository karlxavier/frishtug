class User::BaseController < ApplicationController
  protect_from_forgery with: :null_session
  before_action :authenticate_user!, :set_full_name, :set_current_order
  layout 'user_dashboard'

  private

  def set_full_name
    session[:full_name] = current_user.full_name || 'guest'
  end

  def set_current_order
    @current_order ||= current_user.orders.placed_between?(range).first
  end

  def range
    DateRange.new(Time.current.beginning_of_day, Time.current.end_of_day)
  end
end
