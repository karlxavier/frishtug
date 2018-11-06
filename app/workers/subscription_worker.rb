class SubscriptionWorker
  include Sidekiq::Worker

  def perform(user_id)
    user = User.find(user_id)
    subscription = Stripe::Subscription.create(
      customer: user.stripe_customer_id,
      billing: 'send_invoice',
      items: [
        {
          plan: user.plan.stripe_plan_id
        }
      ]
    )
    user.update_attributes(
      stripe_subscription_id: subscription.id,
      subscribe_at: Time.current
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