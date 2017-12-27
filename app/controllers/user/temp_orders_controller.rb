class User::TempOrdersController < User::BaseController
  before_action :set_temp_order, only: [:store, :remove, :persist]
  before_action :set_menu, only: [:store, :remove]
  respond_to :js, only: [:store, :remove, :persist]

  def store
    @temp_order.store(@menu, quantity)
    respond_with(@temp_order, @menu, menu_size)
  end

  def remove
    @temp_order.remove_item(@menu, quantity)
    respond_with(@temp_order, @menu, menu_size)
  end

  def persist
    @order = @temp_order.save_as_order!(current_user)
    respond_with(@order)
  end

  private

  def quantity
    params[:quantity]
  end

  def order_date
    Time.zone.parse(params[:date])
  end

  def set_temp_order
    @temp_order = current_user.temp_orders.find_by_order_date(order_date)
  end

  def set_menu
    @menu = Menu.find(params[:menu_id])
  end

  def menu_size
    menu = @temp_order.menus_temp_orders.where(menu_id: @menu.id).first || NullMenuOrders.new(@menu)
    @menu_size = menu.quantity
  end
end
