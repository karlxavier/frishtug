class StripeSubscriptioner
  include ActiveModel::Validations

  def initialize(user)
    @user = user
  end

  def run
    customer = find_or_create_stripe_customer
    subscription = subscribe_customer(customer.id)
    update_user(customer.id, subscription)
    true
  rescue Stripe::StripeError => e
    errors.add(:base, e.message)
    false
  end

  def retrieve
    return false if user_not_subscribed?
    Rails.cache.fetch([user, "stripe retrieve"], expires: 1.hour) do
      Stripe::Subscription.retrieve(user.stripe_subscription_id)
    end
  end

  def cancel
    subscription = retrieve
    subscription.delete
    true
  rescue Stripe::InvalidRequestError => e
    logger.error "Stripe error while canceling the subscription: #{e.message}"
    errors.add :base, e.message
    false
  end

  private

  attr_accessor :user

  def find_or_create_stripe_customer
    if existing_stripe_customer?
      Stripe::Customer.retrieve(user.stripe_customer_id)
    else
      create_stripe_customer
    end
  end

  def existing_stripe_customer?
    return true unless user.stripe_customer_id.nil?
    false
  end

  def user_not_subscribed?
    unless user.stripe_subscription_id?
      errors.add(:user, 'is not subscribe.')
      return true
    end
    false
  end

  def update_user(customer_id, subscription)
    user.update_attributes(
      stripe_customer_id: customer_id,
      stripe_subscription_id: subscription.id,
      subscribe_at: Time.at(subscription.current_period_start)
    )
  end

  def create_stripe_customer
    Stripe::Customer.create(
      email: user.email,
      description: description,
      source: user.stripe_token
    )
  end

  def description
    "Frishtug customer ##{user.id}, #{user.full_name} <#{user.email}>"
  end

  def subscribe_customer(customer_id)
    Stripe::Subscription.create(
      customer: customer_id,
      billing_cycle_anchor: billing_cycle_anchor,
      prorate: false,
      items: [
        {
          plan: user.plan.stripe_plan_id
        }
      ]
    )
  end

  def billing_cycle_anchor
    user.orders.first.placed_on.to_i
  end
end
