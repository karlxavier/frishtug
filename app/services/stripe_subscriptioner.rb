class StripeSubscriptioner
  include ActiveModel::Validations

  def initialize(user)
    @user = user
  end

  def run
    begin
      customer     = create_stripe_customer
      subscription = subscribe_customer(customer.id)
      update_user(customer, subscription)
      true
    rescue Stripe::StripeError => e
      errors.add(:credit_card, e.message)
      false
    end
  end

  def retrieve
    return false if user_not_subscribed?
    Stripe::Subscription.retrieve(user.stripe_subscription_id)
  end

  def cancel
    subscription = retrieve
    if subscription
      subscription.delete
      true
    end

    false
  end

private

  attr_accessor :user

  def user_not_subscribed?
    if !user.stripe_subscription_id?
      errors.add(:user, 'is not subscribe.')
      return true
    end
    false
  end

  def update_user(customer, subscription)
    user.update_attributes(
      stripe_customer_id: customer.id,
      stripe_subscription_id: subscription.id
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