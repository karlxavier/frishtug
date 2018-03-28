class StockAccounter
  attr_accessor :stock, :range, :date, :inventory
  def initialize(stock, date)
    @stock = stock
    @date = date
    @range = DateRange.new(date.beginning_of_day, date.end_of_day)
    @inventory = stock.inventory
  end

  def increase
    return if inventory.nil?
    transaction = inventory.inventory_transactions
                            .between_transaction_date?(range)
                            .first_or_create(
                              transaction_date: date,
                              quantity_sold: 0
                            )
    transaction.quantity_on_hand = stock.inventory.quantity
    transaction.quantity_sold += stock.quantity
    transaction.save
  end

  def decrease
    return if inventory.nil?
    transaction = inventory.inventory_transactions
                            .between_transaction_date?(range)
                            .first_or_create(
                              transaction_date: date,
                              quantity_sold: 0
                            )
    transaction.quantity_on_hand = stock.inventory.quantity
    transaction.quantity_sold -= stock.quantity

    if transaction.quantity_sold == 0
      transaction.destroy
    else
      transaction.save!
    end
  end
end