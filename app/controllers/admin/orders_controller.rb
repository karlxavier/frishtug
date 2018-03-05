class Admin::OrdersController < Admin::BaseController
  def show
    @order = Order.find(params[:id])
  end

  def edit
    @client_order = Order.find(order_id)
    @order = @client_order
    @menus = Menu.all_published.order(name: :asc).pluck(:name, :id)
  end

  def update
    @order = Order.find(params[:id])
    if @order.update_attributes(order_params)
      render json: { status: 'success', order: @order }, status: :ok
    else
      render json: { status: 'error', message: @order.errors.full_messages.join(', ') }, status: :unprocessable_entity
    end
  end

  private

  def order_params
    params.require(:order)
          .permit(
            :id,
            :user_id,
            :placed_on,
            :eta,
            :order_date,
            :delivered_at,
            :delivery_status,
            :payment_details,
            :route_started,
            :series_number,
            :sku,
            :status,
            :remarks,
            menus_orders_attributes: [:id, :menu_id, :quantity, :add_ons, :_destroy]
          )
  end

  def order_id
    params[:order_id]
  end
end
