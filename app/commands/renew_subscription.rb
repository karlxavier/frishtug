class RenewSubscription
  prepend SimpleCommand

  def initialize(user:, time:)
    @user = user
    @time = time
  end

  def call
    process_renewal!
  end

  private

  attr_accessor :user, :time

  def process_renewal!
    if delete_old_subscription!
      create_new_subscription!
    end
  end

  def delete_old_subscription!
    old_subscription = Stripe::Subscription.retrieve(user.stripe_subscription_id)
    old_subscription.delete
    true
  rescue => e
    errors.add(:subscription, e.message)
    false
  end

  def create_new_subscription!
    subscription = Stripe::Subscription.create(
      :customer => user.stripe_customer_id,
      :items => [
        {
          :plan => user.plan.stripe_plan_id,
        },
      ]
    )
    update_user(subscription)
  rescue => e
    errors.add(:subscription, e.message)
  end

  def update_user(subscription)
    user.update_attributes(
    stripe_subscription_id: subscription.id,
    subscribe_at: time,
    plan_id: user.plan.id)
  end
end