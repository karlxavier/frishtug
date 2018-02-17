class Admin::DashboardController < Admin::BaseController
  before_action :set_date

  def index
    @order_query = OrderQuery.new(range, location, meal_plan_ids)
  end

  private

  def range
    DateRange.new(@date.beginning_of_day, @date.end_of_day)
  end

  def set_date
    @date = Date.parse(params[:date]) rescue Date.current
  end

  def location
    params[:location]
  end

  def meal_plan_ids
    params[:meal]
  end
end
