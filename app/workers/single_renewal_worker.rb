class SingleRenewalWorker
  include Sidekiq::Worker
  CURRENT_TIME=Time.current.freeze

  def perform(user_id, attempt)
    return if attempt > 3
    user = User.find(user_id)

    return if user.stripe_subscription_id.nil?
    old_start_date = user.subscribe_at
    old_end_date = user.subscription_expires_at
    plan_id = user.plan_id

    begin
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
        subscribe_at: CURRENT_TIME + 1.day,
        plan_id: plan_id)

      OrderCopierWorker.perform_async(user.id, old_start_date, old_end_date)
      if user.plan.per_month?
        charge = StripeCharger.new(user, user.plan.shipping_fee)
        charge.charge_shipping
        user.bill_histories.create!(
          amount_paid: user.plan.shipping_fee,
          description: 'Shipping Charge',
          billed_at: Time.current,
        )
      end
    rescue => e
      attempt += 1
      attempt_time = case attempt
      when 1..2
        4.hours.from_now
      when 3
        8.hours.from_now
      end

      SingleRenewalWorker.perform_at(attempt_time, user.id, attempt)
    end
  end
end