class User::OrdersController < User::BaseController
  before_action :set_order, :set_menu, :set_cart, only: [:store, :remove]
  respond_to :js

  def store
    if @cart.place_order(@menu, quantity, add_on_id)
      respond_with(@order, @menu, menu_size)
    end
  end

  def remove
    if @cart.remove_order(@menu, quantity, add_on_id)
      respond_with(@order, @menu, menu_size)
    end
  end

  def persist
    @order = Order.find(order_id)
    ChargeUser.call(@order, current_user)
    if @order.fresh?
      @order.update_attributes(order_date: Time.current, status: :processing)
    end
  end

  def cancel
    @order = Order.find(order_id)
    cancel_order = CancelOrder.new(@order, current_user)
    if cancel_order.run
      respond_with(@order)
    end
  end

  def undo_cancel
    @order = Order.find(order_id)
    uncancel_order = UncancelOrder.new(@order, current_user)
    if uncancel_order.run
      respond_with(@order)
    end
  end

  private

  def order_id
    params[:order_id]
  end

  def add_on_id
    params[:add_on_id]
  end

  def quantity
    params[:quantity]
  end

  def placed_on
    Time.zone.parse(params[:date])
  end

  def set_order
    @order = current_user.orders.find_by_placed_on(placed_on)
  end

  def set_menu
    @menu = Menu.find(params[:menu_id])
  end

  def set_cart
    @cart = ShoppingCart.new(@order)
  end

  def menu_size
    menu = @order.menus_orders.where(menu_id: @menu.id).first || NullMenuOrders.new(@menu)
    @menu_size = menu.quantity
  end
end
