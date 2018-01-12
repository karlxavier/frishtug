class Admin::ShoppingsListsController < Admin::BaseController
  before_action :set_date
  CURRENT_DATE = Date.current + 2.day
  def index
    range = DateRange.new(@date.beginning_of_day, @date.end_of_day)
    @shopping_lists = Menu.shopping_lists?(range)
  end

  private

  def set_date
    @date = Date.parse(params[:date]) rescue CURRENT_DATE
  end
end
