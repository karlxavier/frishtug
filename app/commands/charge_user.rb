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
    calculate_payment
    return order unless amount_valid?
    stripe = StripeCharger.new(user, @amount_to_pay).run
    if stripe[:success]
      create_bill_history("Order Charge", stripe[:response].id)
      order.update_attributes(charge_id: stripe[:response].id)
      RecordLedger.new(user, order).record_shipping! if user.plan.party_meeting?
      order.awaiting_shipment! unless user.plan.party_meeting?
      return order
    else
      errors.add(:charge, stripe.errors.full_messages.join(", "))
    end
    nil
  end

  def create_ledger!
    if RecordLedger.new(user, order).record!(notify_user: false)
      return order
    else
      return order
    end
  end

  def create_bill_history(description, charge_id)
    order.bill_histories.create!(
      amount_paid: @amount_to_pay,
      user: user,
      description: description,
      billed_at: order.placed_on,
      charge_id: charge_id,
    )
    order.paid!
    order
  end

  def calculate_payment
    amount = OrderCalculator.new(order).total
    amount -= last_bill_amount("Order Charge")
    @amount_to_pay = amount
  end

  def amount_is_negative?
    @amount_to_pay < 0
  end

  def amount_valid?
    @amount_to_pay >= STRIPE_MINIMUM_AMOUNT
  end
end
