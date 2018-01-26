class InventoryAccounter

  def initialize(order)
    @order = order
    @date = order.placed_on
  end

  def run
    update_inventory_and_create_transactions
  end

  private

  attr_accessor :order, :date

  def update_inventory_and_create_transactions
    order.menus_orders.each do |menu_order|
      inventory = Inventory.find_by_menu_id(menu_order.menu_id)
      inventory.quantity -= menu_order.quantity
      inventory.save
      create_inventory_transaction(inventory, inventory.quantity, menu_order.quantity)
    end
  end

  def create_inventory_transaction(inventory, remaining_quantity, sold_quantity)
    inventory.inventory_transactions.between_transaction_date?(range)
             .first_or_create(
               transaction_date: date,
               quantity_sold: sold_quantity,
               quantity_on_hand: remaining_quantity
             )
  end

  def range
    DateRange.new(date.beginning_of_day, date.end_of_day)
  end
end
