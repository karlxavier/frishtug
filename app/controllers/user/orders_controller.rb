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
    charge_user!
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
    if @order.processing!
      respond_with(@order)
    end
  end

  private

  def charge_user!
    if current_user.subscribed?
      plan_limit = current_user.plan.limit
      amount_to_pay = OrderCalculator.new(@order).total_excess(plan_limit)
      create_excess_charge!(amount_to_pay) if amount_to_pay > 0
    else
      amount_to_pay = OrderCalculator.new(@order).total
      create_charge!(amount_to_pay)
    end
  end

  def create_excess_charge!(amount_to_pay)
    StripeCharger.new(current_user, amount_to_pay).charge_excess!
  end

  def create_charge!(amount_to_pay)
    StripeCharger.new(current_user, amount_to_pay).run
  end

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
