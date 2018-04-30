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
    calculate_payment
    return unless amount_valid?
    stripe = StripeCharger.new(user, @amount_to_pay)
    if stripe.run
      create_bill_history('Order charge')
    else
      errors.add(:charge, stripe.errors)
    end
    nil
  end

  def charge_excess!
    calculate_payment
    return unless amount_valid?
    stripe = StripeCharger.new(user, @amount_to_pay)
    if stripe.charge_excess!
      return create_bill_history('Excess charge')
    else
      errors.add(:charge, stripe.errors)
    end
    nil
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

  def calculate_payment
    if subscribed?
      amount = OrderCalculator.new(order).total_excess(plan_limit)
    else
      amount = OrderCalculator.new(order).total
    end
    amount -= last_bill_amount
    @amount_to_pay = deduct_pending_credit(amount)
  end

  def amount_valid?
    @amount_to_pay > STRIPE_MINIMUM_AMOUNT
  end

  def pending_credit
    user.pending_credits.activate_on(order.placed_on)
  end

  def deduct_pending_credit(amount)
    return amount unless pending_credit.present?

    pending_amount = pending_credit.amount || 0
    total = 0

    return unless pending_amount > 0
    total = pending_amount - amount
    if total < 0
      pending_credit.destroy
      return total.abs
    else
      pending_credit.amount = total
      pending_credit.save
      return 0
    end
  end
end