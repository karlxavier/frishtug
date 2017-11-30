class User::OrdersController < User::BaseController
  before_action :set_order, only: [:store, :remove]
  before_action :set_menu, only: [:store, :remove]
  respond_to :js, only: [:store, :remove]

  def store
    @order.menus << @menu
    @order.save
    respond_with(@order, @menu, menu_size)
  end

  def remove
    menus = @order.menus.where(id: params[:menu_id])
    size = menus.size
    @order.menus.delete(@menu)
    if size > 1
      (size - 1).times { @order.menus << @menu }
    end
    respond_with(@order, @menu, menu_size)
  end

  private

  def placed_on
    Time.zone.parse(params[:date])
  end

  def set_order
    @order = current_user.orders.find_by_placed_on(placed_on)
  end

  def set_menu
    @menu = Menu.find(params[:menu_id])
  end

  def menu_size
    @menu_size = @order.menus.where(id: params[:menu_id]).size
  end
end