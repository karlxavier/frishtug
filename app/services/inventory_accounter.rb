class InventoryAccounter

  def initialize(order)
    @order = order
    @date = order.placed_on
  end

  def run
    update_inventory_and_create_transactions
  end

  def re_account
    re_account_inventory_and_transaction
    return @order.menus_orders
    true
  end

  private

  attr_accessor :order, :date

  def re_account_inventory_and_transaction
    order.menus_orders.each do |menu_order|
      return_stocks(menu_order.menu_id, menu_order.quantity)
      return_add_ons_inventory(menu_order)
    end
  end

  def return_add_ons_inventory(menu_order)
    add_ons_menu_ids = AddOn.pluck(:id, :menu_id).to_h
    menu_order.add_ons.each do |add_on|
      return_stocks(add_ons_menu_ids[add_on.to_i], menu_order.quantity)
    end
  end

  def return_stocks(menu_id, quantity)
    stock = Stock.new(menu_id, quantity)
    stock_accounter = StockAccounter.new(stock, date)
    stock.return
    stock_accounter.decrease
  end

  def update_inventory_and_create_transactions
    order.menus_orders.each do |menu_order|
      update_stocks(menu_order.menu_id, menu_order.quantity)
      update_add_ons_inventory(menu_order)
    end
  end

  def update_add_ons_inventory(menu_order)
    add_ons_menu_ids = AddOn.pluck(:id, :menu_id).to_h
    menu_order.add_ons.each do |add_on|
      update_stocks(add_ons_menu_ids[add_on.to_i], menu_order.quantity)
    end
  end

  def update_stocks(menu_id, quantity)
    stock = Stock.new(menu_id, quantity)
    stock_accounter = StockAccounter.new(stock, date)
    stock.reduce
    stock_accounter.increase
  end
end
