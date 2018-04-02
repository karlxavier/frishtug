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
      last_bill = @order.bill_histories.last
      amount_to_pay = OrderCalculator.new(@order).total_excess(plan_limit)
      return if amount_to_pay == 0
      return create_excess_charge!(amount_to_pay) if last_bill.nil?
      if amount_to_pay > last_bill.amount_paid
        new_amount_to_pay = amount_to_pay - last_bill.amount_paid
        return create_excess_charge!(new_amount_to_pay) 
      end
    else
      amount_to_pay = OrderCalculator.new(@order).total
      last_bill = @order.bill_histories.last
      return create_charge!(amount_to_pay) if last_bill.nil?
      if amount_to_pay > last_bill.amount_paid
        new_amount_to_pay = amount_to_pay - last_bill.amount_paid
        return create_charge!(new_amount_to_pay) 
      end
    end
  end

  def create_excess_charge!(amount_to_pay)
    stripe =  StripeCharger.new(current_user, amount_to_pay)
    if stripe.charge_excess!
      @order.bill_histories.create!(
        amount_paid: amount_to_pay, 
        user: current_user, 
        description: "Excess Charge",
        billed_at: @order.placed_on
      )
      @order.paid!
    end
  end

  def create_charge!(amount_to_pay)
    stripe = StripeCharger.new(current_user, amount_to_pay)
    if stripe.run
      @order.bill_histories.create!(
        amount_paid: amount_to_pay, 
        user: current_user, 
        description: "Order Charge",
        billed_at: @order.placed_on
      )
      @order.paid!
    end
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
