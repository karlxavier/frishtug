class ChargeUser
  prepend SimpleCommand
  STRIPE_MINIMUM_AMOUNT = 0.50.freeze

  def initialize(order, user)
    @user = user
    @order = order
    @amount_to_pay = 0
  end

  def call
    charge_user!
  end

  private

  attr_reader :order, :user

  def charge_user!
    subscribed? ? create_ledger! : charge!
  end

  def subscribed?
    user.subscribed?
  end

  def plan_limit
    user.plan.limit
  end

  def last_bill(description)
    order.bill_histories.where(description: description).last
  end

  def last_bill_amount(description)
    bill = last_bill(description)
    return 0 unless bill.present?
    bill.amount_paid
  end

  def charge!
    calculate_payment('charge')
    return order unless amount_valid?
    stripe = StripeCharger.new(user, @amount_to_pay)
    if stripe.run
      create_bill_history('Order Charge')
      return order
    else
      errors.add(:charge, stripe.errors.full_messages.join(', '))
    end
    nil
  end

  def create_ledger!
    if RecordLedger.new(user, order).record!(notify_user: true)
      return order
    else
      return order
    end
  end

  def create_bill_history(description)
    order.bill_histories.create!(
      amount_paid: @amount_to_pay,
      user: user,
      description: description,
      billed_at: order.placed_on
    )
    order.paid!
    order
  end

  def calculate_payment(type)
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
    @amount_to_pay = deduct_pending_credit(amount)
  end

  def amount_is_negative?
    @amount_to_pay < 0
  end

  def amount_valid?
    @amount_to_pay >= STRIPE_MINIMUM_AMOUNT
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
end