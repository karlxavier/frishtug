class User::DuplicateMealsController < User::BaseController
  before_action :set_order, only: :create
  def create
    @order_duplicator = OrderDuplicator.new(@order, date)
    if @order_duplicator.run
      flash[:success] = "Order successfully duplicated"
      redirect_to edit_user_weekly_meals_path(date: date)
    end
  end

  private

  def date
    params[:date]
  end

  def order_id
    params[:order_id]
  end

  def set_order
    if order_id.present?
      @order = Order.find(order_id)
    else
      flash[:error] = "Please select a date to duplicate!"
      redirect_back fallback_location: :back
    end
  end
end