class Admin::DashboardController < Admin::BaseController
  def index
    current_date = Date.current
    date_range = DateRange.new(current_date.beginning_of_day, current_date.end_of_day)
    @order_query = OrderQuery.new(date_range)
  end
end
