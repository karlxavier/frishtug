module InventoryAccounting
  extend ActiveSupport::Concern

  included do
    after_update :create_inventory_transactions!
  end

  private

  def create_inventory_transactions!
    return unless completed?

    menus_orders.each { |menu_order| create_transactions(menu_order) }
  end

  def create_transactions(menu_order)
    inventory = Inventory.where(menu_id: menu_order.menu_id).last
    transaction =
      inventory.inventory_transactions.between_transaction_date?(range)
               .first_or_create!(
                 transaction_date: time_today,
                 quantity_sold: 0,
                 quantity_on_hand: inventory.quantity)

    transaction.quantity_sold += menu_order.quantity
    transaction.quantity_on_hand -= menu_order.quantity
    transaction.save!
  end

  def time_today
    Time.current
  end

  def range
    DateRange.new(time_today.beginning_of_day, time_today.end_of_day)
  end
end
