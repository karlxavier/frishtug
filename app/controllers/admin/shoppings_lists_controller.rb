class Admin::ShoppingsListsController < Admin::BaseController
  before_action :set_date
  CURRENT_DATE = Date.current.tomorrow

  def index
    @shopping_lists = ShoppingListQuery.new(@date).get_list
  end

  private

  def set_date
    @date = Date.parse(params[:date]) rescue CURRENT_DATE
  end
end
