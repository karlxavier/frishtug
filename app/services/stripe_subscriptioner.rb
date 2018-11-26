class StripeSubscriptioner
  include ActiveModel::Validations

  def initialize(user)
    @user = user
  end

  def run
    customer = find_or_create_stripe_customer
    subscription = subscribe_customer(customer.id)
    create_schedule(user)
    update_user_subscription(customer, subscription)
    true
  rescue Stripe::StripeError => e
    errors.add(:base, e.message)
    false
  end

  def retrieve
    return nil if user_not_subscribed?
    Rails.cache.fetch([user, "stripe retrieve"], expires: 1.hour) do
      Stripe::Subscription.retrieve(user.stripe_subscription_id)
    end
  end

  def cancel
    unless user.stripe_subscription_id?
      errors.add :base, "You cant cancel a subscription that is not active."
      return
    end
    subscription = retrieve
    subscription.delete
    update_cancelled_subscription
    true
  rescue => e
    logger.error "Stripe error while canceling the subscription: #{e.message}"
    errors.add :base, e.message
    false
  end

  private

  attr_accessor :user

  def update_cancelled_subscription
    user.update_attributes(
      stripe_subscription_id: nil,
      subscribe_at: nil,
      subscription_expires_at: nil,
      plan_id: nil,
    )
  end

  def update_user_subscription(customer, subscription)
    user.update_attributes(
      stripe_customer_id: customer.id,
      stripe_subscription_id: subscription.id,
      subscribe_at: Time.current,
    )
  end

  def create_schedule(user)
    schedule = Schedule.where(user_id: user.id).first_or_create!(option: :monday_to_friday)
    schedule.start_date = Time.current
    schedule.save
  end

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
      errors.add(:user, "is not subscribe.")
      return true
    end
    false
  end

  def create_stripe_customer
    Stripe::Customer.create(
      email: user.email,
      description: description,
      source: user.stripe_token,
    )
  end

  def description
    "Frishtug customer ##{user.id}, #{user.full_name} <#{user.email}> "
  end

  def subscribe_customer(customer_id)
    Stripe::Subscription.create(
      customer: customer_id,
      items: [
        {
          plan: user.plan.stripe_plan_id,
        },
      ],
    )
  end
end
