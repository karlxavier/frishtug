class SubscriptionWorker
  include Sidekiq::Worker

  def perform(user_id)
    user = User.find(user_id)
    subscription = Stripe::Subscription.create(
      customer: user.stripe_customer_id,
      items: [
        {
          plan: user.plan.stripe_plan_id
        }
      ]
    )

    subscription_start = Time.zone.at(subscription.billing_cycle_anchor)
    subscription_end = Time.zone.at(subscription.current_period_end)
    user.update_attributes(
      stripe_subscription_id: subscription.id,
      subscribe_at: subscription_start,
      subscription_expires_at: subscription_end
    )
    create_bill_history(user)
  end

  private

    def create_bill_history(user)
      user.bill_histories.create!(
        amount_paid: user.plan.price,
        description: 'Subscription Payment!',
        billed_at: Time.current
      )
    end
end