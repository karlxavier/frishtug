class InventoryAccounter
  CURRENT_TIME = Time.current

  def initialize(order)
    @order = order
  end

  def run
    update_inventory_and_create_transactions
  end

  private

  attr_accessor :order

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
               transaction_date: CURRENT_TIME,
               quantity_sold: sold_quantity,
               quantity_on_hand: remaining_quantity
             )
  end

  def range
    DateRange.new(CURRENT_TIME.beginning_of_day, CURRENT_TIME.end_of_day)
  end
end
