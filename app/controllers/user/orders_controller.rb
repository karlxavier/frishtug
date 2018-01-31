class User::OrdersController < User::BaseController
  before_action :set_order, :set_menu, :set_cart, only: [:store, :remove]
  respond_to :js, only: [:store, :remove]

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
  end

  private

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