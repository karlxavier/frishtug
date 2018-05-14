class User::DuplicateMealsController < User::BaseController
  before_action :set_order, only: :create
  def create
    @order = Order.find(params[:order])
    @order_duplicator = OrderDuplicator.new(@order_to_cop, date, @order)
    if @order_duplicator.run
      flash[:success] = "Order successfully duplicated"
      flash[:notice] = @order_duplicator.notices.join(', ') if @order_duplicator.notices.present?
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
      @order_to_cop = Order.find(order_id)
    else
      flash[:error] = "Please select a date to duplicate!"
      redirect_back fallback_location: :back
    end
  end
end