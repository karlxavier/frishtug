class Admin::OrdersController < Admin::BaseController
  before_action :set_order
  def show
    respond_to :html, :js
  end

  def edit
    @menus = Menu.all_published.order(name: :asc).pluck(:name, :id)
  end

  def update
    has_menu_items_quantity_changed?
    if @order.update_attributes(order_params)
      render json: { status: 'success', order: @order }, status: :ok
    else
      render json: { status: 'error', message: @order.errors.full_messages.join(', ') }, status: :unprocessable_entity
    end
  end

  private

  def set_order
    @order = Order.find(params[:id])
  end

  def has_menu_items_quantity_changed?
    order_params[:menus_orders_attributes].each do |item|
      AdminStockAccounter.new(item, order_params[:placed_on]).run
    end
  end

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
end
