class StockAccounter
  attr_accessor :stock, :range, :date_begin, :inventory, :transaction
  def initialize(stock, date)
    @stock = stock
    @date_begin = date.beginning_of_day
    @inventory = stock.inventory
    @transaction = set_transaction
  end

  def increase
    return unless transaction.present?
    transaction.quantity_on_hand = stock.inventory.quantity
    transaction.save!
    transaction.increment! :quantity_sold, stock.quantity
  end

  def decrease
    return unless transaction.present?
    transaction.quantity_on_hand = stock.inventory.quantity
    transaction.save!
    transaction.decrement! :quantity_sold, stock.quantity

    if transaction.quantity_sold <= 0
      transaction.destroy
    end
  end

  private

  attr_accessor :date_begin, :inventory

  def set_transaction
    return nil unless inventory.present?
    inventory.inventory_transactions
                            .where(transaction_date: date_begin)
                            .first_or_create(
                              transaction_date: date_begin,
                              quantity_sold: 0
                            )
  end
end