class ChargeUser
  prepend SimpleCommand
  STRIPE_MINIMUM_AMOUNT = 0.50.freeze

  def initialize(order, user)
    @user = user
    @order = order
    @amount = 0
  end

  def call
    charge_user!
  end

  private

  attr_reader :order, :user
  attr_accessor :amount

  def charge_user!
    subscribed? ? charge_excess! : charge!
  end

  def subscribed?
    user.subscribed?
  end

  def plan_limit
    user.plan.limit
  end

  def last_bill
    order.bill_histories.last
  end

  def last_bill_amount
    last_bill&.amount_paid || 0
  end

  def charge!
    return if amount_valid?
    stripe = StripeCharger.new(user, amount)
    if stripe.run
      raise create_bill_history('Order charge').inspect
    else
      errros.add(:charge, stripe.errors)
    end
    nil
  end

  def charge_excess!
    return if amount_valid?
    stripe = StripeCharger.new(user, amount)
    if stripe.charge_excess!
      return create_bill_history('Excess charge')
    else
      errros.add(:charge, stripe.errors)
    end
    nil
  end

  def create_bill_history(description)
    order.bill_histories.create!(
      amount_paid: amount,
      user: user,
      description: description,
      billed_at: order.placed_on
    )
    order.paid!
    order
  end

  def amount_to_pay
    if subscribed?
      amount = OrderCalculator.new(order).total
    else
      amount = OrderCalculator.new(order).total_excess(plan_limit)
    end
    amount -= last_bill_amount
  end

  def amount_valid?
    amount_to_pay < STRIPE_MINIMUM_AMOUNT
  end
end