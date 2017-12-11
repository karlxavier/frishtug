class Admin::ShoppingsListsController < Admin::BaseController
  CURRENT_DATE = Date.current

  def index
    range = DateRange.new(CURRENT_DATE.beginning_of_day, CURRENT_DATE.end_of_day)
    @date = CURRENT_DATE.strftime('%B %d')
    @shopping_lists = Menu.shopping_lists?(range)
  end
end
