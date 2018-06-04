class CalculateAmount
  prepend SimpleCommand

  def initialize(user, order, type)
    @user = user
    @order = order
    @type = type
  end

  def call
    amount = calculate_payment
    if amount > 0 
      amount
    else
      0
    end
  end

  private

  attr_accessor :user, :order, :type

  def last_bill(description)
    order.bill_histories.where(description: description).last
  end

  def last_bill_amount(description)
    bill = last_bill(description)
    return 0 unless bill.present?
    bill.amount_paid
  end

  def calculate_payment
    calculations_type = {
      'excess' => OrderCalculator.new(order).total_excess,
      'tax' => OrderCalculator.new(order).total_tax,
      'charge' => OrderCalculator.new(order).total
    }

    charge_description = {
      'excess' => "Excess Charge",
      'tax' => "Tax Charge",
      'charge' => "Order Charge"
    }
    amount = calculations_type[type]
    amount -= last_bill_amount(charge_description[type])
    amount
  end
end
