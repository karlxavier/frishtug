class StripeSubscriptioner
  include ActiveModel::Validations

  def initialize(user)
    @user = user
  end

  def run
    customer = create_stripe_customer
    subscribe_customer(customer.id)
    update_user(customer.id)
    true
  rescue Stripe::CardError => e
    errors.add(:credit_card, e.message)
  end

private

  attr_accessor :user

  def update_user(customer_id)
    user.update_attributes(
      stripe_customer_id: customer_id
    )
  end

  def create_stripe_customer
    Stripe::Customer.create(
      email: user.email,
      source: user.stripe_token
    )
  end

  def subscribe_customer(customer_id)
    Stripe::Subscription.create(
      customer: customer_id,
      items: [
        {
          plan: user.plan.stripe_plan_id
        }
      ]
    )
  end
end