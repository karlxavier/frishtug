class StripeCharger
  include ActiveModel::Validations

  def initialize(user, amount)
    @user = user
    @amount = amount
  end

  def run
    Stripe::Charge.create(
      amount: amount_to_cents,
      currency: 'usd',
      source: @user.stripe_token,
      description: "Single Order Charge for #{@user.full_name} <#{@user.email}>"
    )
    true
  rescue Stripe::InvalidRequestError => e
    errors.add(:base, e.message)
    false
  end

  private

  attr_accessor :amount, :user

  def amount_to_cents
    ((amount + user.plan.shipping_fee).to_f * 100).to_i
  end
end
