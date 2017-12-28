class Admin::DashboardController < Admin::BaseController
  before_action :set_date

  def index
    date_range = DateRange.new(@date.beginning_of_day, @date.end_of_day)
    @order_query = OrderQuery.new(date_range)
  end

  private

  def set_date
    @date = Date.parse(params[:date]) rescue Date.current
  end
end
