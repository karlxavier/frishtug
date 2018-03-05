class AdminStockAccounter
  def initialize(item, placed_on)
    @item = item
    @placed_on = Time.zone.parse(placed_on)
  end

  def run
    return reduce_stock_for_new_entries! if is_new_entry?
    menu_order = MenusOrder.find(@item[:id])
    return reduce_stock_for_increase_quantity!(menu_order) if quantity_increased?(menu_order)
    return return_stock_for_decrease_quantity!(menu_order) if quantity_decreased?(menu_order)
  end

  private

  attr_accessor :item, :placed_on

  def is_new_entry?
    item[:id].nil?
  end

  def reduce_stock_for_new_entries!
    stock = Stock.new(item[:menu_id], item[:quantity])
    stock.reduce
    StockAccounter.new(stock, placed_on).increase
    reduce_add_on_stock!(item[:quantity])
    true
  end

  def quantity_increased?(menu_order)
    quantity = item[:quantity].to_i
    quantity > menu_order.quantity
  end

  def quantity_decreased?(menu_order)
    quantity = item[:quantity].to_i
    menu_order.quantity > quantity
  end

  def reduce_stock_for_increase_quantity!(menu_order)
    new_quantity = item[:quantity].to_i - menu_order.quantity
    stock = Stock.new(item[:menu_id], new_quantity)
    stock.reduce
    StockAccounter.new(stock, placed_on).increase
    reduce_add_on_stock!(new_quantity)
    true
  end

  def return_stock_for_decrease_quantity!(menu_order)
    new_quantity = menu_order.quantity - item[:quantity].to_i
    stock = Stock.new(item[:menu_id], new_quantity)
    stock.return
    StockAccounter.new(stock, placed_on).decrease
    return_add_on_stock!(new_quantity)
    true
  end

  def reduce_add_on_stock!(quantity)
    return if item[:add_ons].blank?
    item[:add_ons].each do |a|
      add_on = AddOn.find(a)
      next if add_on.menu_id.present?
      stock = Stock.new(add_on.menu_id, quantity)
      stock.reduce
      StockAccounter.new(stock, placed_on).increase
    end
  end

  def return_add_on_stock!(quantity)
    return if item[:add_ons].blank?
    item[:add_ons].each do |a|
      add_on = AddOn.find(a)
      next if add_on.menu_id.present?
      stock = Stock.new(add_on.menu_id, quantity)
      stock.return
      StockAccounter.new(stock, placed_on).decrease
    end
  end
end