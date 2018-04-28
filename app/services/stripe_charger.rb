class StripeCharger
  include ActiveModel::Validations

  def initialize(user, amount)
    @user = user
    @amount = amount
  end

  def run
    create_a_customer
    Stripe::Charge.create(
      amount: amount_to_cents,
      currency: 'usd',
      customer: @user.stripe_customer_id,
      description: "Single Order Charge for #{@user.full_name} <#{@user.email}>"
    )
    true
  rescue Stripe::InvalidRequestError => e
    errors.add(:base, e.message)
    false
  end

  def charge_excess!
    Stripe::Charge.create(
      amount: to_cents(amount),
      currency: 'usd',
      customer: @user.stripe_customer_id,
      description: "Excess charge"
    )
    true
  rescue Stripe::InvalidRequestError => e
    errors.add(:base, e.message)
    false
  end

  def charge_tax!
    response = Stripe::Charge.create(
      amount: to_cents(amount),
      currency: 'usd',
      customer: @user.stripe_customer_id,
      description: "Excess charge"
    )
    response
  rescue Stripe::InvalidRequestError => e
    errors.add(:base, e.message)
    false
  end

  def charge_shipping
    response = Stripe::Charge.create(
      amount: to_cents(amount),
      currency: 'usd',
      customer: @user.stripe_customer_id,
      description: "Shipping charge"
    )
    response
  rescue Stripe::InvalidRequestError => e
    errors.add(:base, e.message)
    false
  end

  private

  attr_accessor :amount, :user

  def to_cents(amount)
    (amount.to_r * 100).to_i
  end

  def amount_to_cents
    ((amount + user.plan.shipping_fee).to_f * 100).to_i
  end

  def create_a_customer
     customer = StripeCustomer.new(user)
     unless customer.create
      errors.add(:base, customer.errors.full_messages.join(', '))
      raise Stripe::InvalidRequestError
     end
  end
end
