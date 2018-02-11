class InventoryAccounter

  def initialize(order)
    @order = order
    @date = order.placed_on
  end

  def run
    return unless @order.present?
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
      update_add_ons_inventory(menu_order)
    end
  end

  def update_add_ons_inventory(menu_order)
    add_ons_menu_ids = AddOn.pluck(:id, :menu_id).to_h
    menu_order.add_ons.each |add_on|
      inventory = Inventory.find_by_menu_id(add_ons_menu_ids)
      if inventory.present?
        inventory.quantity -= menu_order.quantity
        inventory.save
        create_inventory_transaction(inventory, inventory.quantity, menu_order.quantity)
      end
    end
  end

  def create_inventory_transaction(inventory, remaining_quantity, sold_quantity)
    transaction = inventory.inventory_transactions.between_transaction_date?(range)
             .first_or_initialize(
               transaction_date: date,
               quantity_sold: 0,
               quantity_on_hand: 0
             )
    transaction.quantity_on_hand = remaining_quantity
    transaction.quantity_sold += sold_quantity
    transaction.save
  end

  def range
    DateRange.new(date.beginning_of_day, date.end_of_day)
  end
end
