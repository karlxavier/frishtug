class RenewalWorker
  include Sidekiq::Worker
  CURRENT_TIME=Time.current.freeze

  def perform
    subscribed_users =
      User.joins(:plan).merge(Plan.where.not(interval: [nil, '']))

    subscribed_users.find_each do |user|
      next if user.subscription_expires_at >= CURRENT_TIME

      old_subscription =
        Stripe::Subscription.retrieve(user.stripe_subscription_id)
      old_subscription.delete

      new_subscription = Stripe::Subscription.create(
        :customer => user.stripe_customer_id,
        :items => [
          {
            :plan => user.plan.stripe_plan_id,
          },
        ]
      )

      user.update_attributes(
        stripe_subscription_id: new_subscription.id,
        subscribe_at: Time.zone.at(new_subscription.billing_cycle_anchor))

      OrderCopierWorker.perform_async(user.id)
    end
  end
end