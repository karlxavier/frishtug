class Api::V1::Users::OrdersController < Api::V1::Users::BaseController
  before_action :set_order, only: %i[show update cancel undo_cancel]
  def index
    @orders = current_user.orders
    if @orders
      render jsonapi: @orders
    else
      render jsonapi_errors: 'User has no available orders'
    end
  end

  def show
    if @order
      render jsonapi: @order
    else
      render jsonapi_errors: 'Order not found!'
    end
  end

  def update
    if @order.update_attributes(order_params)
      ChargeUser.call(@order, current_user)
      render jsonapi: @order
    else
      render jsonapi_errors: @order.errors
    end
  end

  def create
    @order = Order.new(order_params)
    if @order.save
      command = ChargeUser.call(@order, current_user)
      render jsonapi: @order
    else
      render jsonapi_errors: @order.errors
    end
  end

  def cancel
    cancel_order = CancelOrder.new(@order, current_user)
    if cancel_order.run
      render jsonapi: @order
    end
  end

  def undo_cancel
    uncancel_order = UncancelOrder.new(@order, current_user)
    if uncancel_order.run
      render jsonapi: @order
    end
  end

  private

  def set_order
    @order = Order.find(params[:id])
  end

  def order_params
    params.require(:order).permit(
      :placed_on,
      :order_date,
      :status,
      :remarks,
      menus_orders_attributes: [
        :id,
        :menu_id,
        :quantity,
        :_destroy,
        add_ons: []
      ]
    ).merge(user_id: current_user.id)
    end
end