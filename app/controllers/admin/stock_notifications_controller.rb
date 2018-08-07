class Admin::StockNotificationsController < Admin::BaseController
  def index
    @inventories = Inventory.includes(:menu).running_out
    render json: { 
      success: true, 
      response: @inventories.map { |i| { name: i.menu.name, quantity: i.quantity } } 
    }, status: :ok
  end
end