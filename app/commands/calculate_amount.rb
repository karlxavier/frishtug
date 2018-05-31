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

  def pending_credit
    user.pending_credits.activate_on(order.placed_on)
  end

  def deduct_pending_credit(amount)
    return amount unless pending_credit.present?

    pending_amount = pending_credit&.amount || 0
    total = 0

    return unless pending_amount > 0
    total = pending_amount - amount
    if total < 0
      pending_credit.destroy
      create_pending_remarks(pending_amount)
      return total.abs
    else
      pending_credit.amount = total
      pending_credit.save
      remarks_amount = amount - pending_amount
      create_pending_remarks(remarks_amount.abs)
      return 0
    end
  end

  def create_pending_remarks(amount)
    return if amount <= 0
    order.remarks = "Used pending credit amount of #{amount.to_f}"
    order.save
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
    amount = deduct_pending_credit(amount)
  end
end
