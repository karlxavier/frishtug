class Admin::DashboardController < Admin::BaseController
  def index
    @order_query = OrderQuery.new
  end
end
