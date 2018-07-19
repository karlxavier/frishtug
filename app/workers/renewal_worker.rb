class RenewalWorker
  include Sidekiq::Worker
  CURRENT_TIME=Time.current.beginning_of_day.freeze

  def perform
    subscribed_users =
      User.joins(:plan).merge(Plan.where.not(interval: [nil, '']))

    subscribed_users.find_each do |user|
      next if user.stripe_subscription_id.nil?
      next if user.subscription_expires_at.nil?
      next if user.subscription_expires_at.beginning_of_day >= CURRENT_TIME
      plan_id = user.plan_id

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
        subscribe_at: Time.current,
        plan_id: plan_id)

      OrderCopierWorker.perform_async(user.id)
      if user.plan.per_month?
        charge = StripeCharger.new(user, user.plan.shipping_fee)
        charge.charge_shipping
        user.bill_histories.create!(
          amount_paid: user.plan.shipping_fee,
          description: 'Shipping Charge',
          billed_at: Time.current,
        )
      end
    end
  end
end