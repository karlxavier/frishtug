class CalendarsController < ApplicationController
  before_action :set_date
  require 'date_helpers/weeks'
  def index
    calendars = []
    calendars << json_object(@date)
    calendars << json_object(@date.next_month)
    render json: calendars
  end

  private

  def json_object(date)
    {
      month: date.strftime('%B %Y'),
      next_month: date.next_month,
      prev_month: date.prev_month,
      days: DateHelpers::Weeks.new(date).full_month_weeks
    }
  end

  def set_date
    @date = Date.parse(params[:date])
  rescue TypeError
    @date = Date.current
  end
end
