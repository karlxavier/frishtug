class User::OrdersController < User::BaseController
  before_action :set_order, :set_menu, :set_cart, :set_order_to_fresh, only: [:store, :remove]
  before_action :set_order_by_id, only: [:persist, :cancel, :undo_cancel, :persist_template]
  respond_to :js, only: [:persist, :persist_template]

  def show
    @order = Order.find(params[:id])
    render json: {
      data: @order
    }, status: :ok
  end

  def store
    if @cart.place_order(@menu, quantity, add_on_id)
      render json: {
        sub_total: @order.sub_total,
        excess: @order.excess,
        tax: @order.total_tax,
        shipping_fee: current_user.subscribed? ? nil : @order.shipping_fee,
        total: @order.total
      }, status: :ok
    end
  end

  def remove
    if @cart.remove_order(@menu, quantity, add_on_id)
      render json: {
        sub_total: @order.sub_total,
        excess: @order.excess,
        tax: @order.total_tax,
        shipping_fee: current_user.subscribed? ? nil : @order.shipping_fee,
        total: @order.total
      }, status: :ok
    end
  end

  def persist
    @command = ChargeUser.call(@order, current_user)
    if @command.success?
      @order.update_attributes(order_date: Time.current)
    end
    @order.fresh! if @order.menus_orders.size == 0
    @order.touch
    respond_with(@order)
  end

  def persist_template
    @order.save
    respond_with(@order)
  end

  def cancel
    cancel_order = CancelOrder.new(@order, current_user)
    if cancel_order.run
      redirect_to user_weekly_meals_path
    end
  end

  def undo_cancel
    uncancel_order = UncancelOrder.new(@order, current_user)
    if uncancel_order.run
      redirect_back fallback_location: :back
    end
  end

  private

  def set_order_by_id
    @order = Order.find(order_id)
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

  def set_order_to_fresh
    @order.fresh! unless @order.fresh? || @order.template?
  end

  def menu_size
    menu = @order.menus_orders.where(menu_id: @menu.id).first || NullMenuOrders.new(@menu)
    @menu_size = menu.quantity
  end
end
