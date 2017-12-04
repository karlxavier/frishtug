class CalendarsController < ApplicationController
  before_action :set_date
  def index
    render json: {
      month: @date.strftime('%B %Y'),
      next_month: @date.next_month,
      prev_month: @date.prev_month,
      days: DateHelpers::Weeks.new(@date).full_month_weeks
    }
  end

  private

  def set_date
    @date = Date.parse(params[:date])
  rescue TypeError
    @date = Date.current
  end
end