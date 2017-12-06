module InventoryAccounting
  extend ActiveSupport::Concern

  included do
    after_update :create_inventory_transactions!
  end

  private

  def create_inventory_transactions!
    return unless self.completed?
    self.menu_ids.each { |menu_id| create_transactions(menu_id) }
  end

  def create_transactions(menu_id)
    inventory = Inventory.find_by_menu_id(menu_id)
    transaction = inventory
                    .inventory_transactions.between_transaction_date?(range)
                    .first_or_create!(
                      transaction_date: time_today,
                      quantity_sold: 0
                    )
    transaction.quantity_sold += 1
    transaction.save!
  end

  def time_today
    Time.current
  end

  def range
    DateRange.new(time_today.beginning_of_day, time_today.end_of_day)
  end
end