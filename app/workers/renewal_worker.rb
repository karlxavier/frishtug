class RenewalWorker
  include Sidekiq::Worker
  CURRENT_TIME=(Time.current + 1.day).freeze

  def perform
    subscribed_users =
      User.joins(:plan).merge(Plan.where.not(interval: [nil, ''])).where(subscription_expires_at: CURRENT_TIME.beginning_of_day..CURRENT_TIME.end_of_day)

    subscribed_users.find_each do |user|
      next if user.stripe_subscription_id.nil?
      plan_id = user.plan_id
      renewal = RenewSubscription.call(user: user, time: CURRENT_TIME)

      unless renewal.errors.any?
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
      else
        first_attempt = 1
        SubscriptionFailedMailer.notify(user_id: user.id, error_message: e.message, attempt_time: 8.hours.from_now).deliver
        SingleRenewalWorker.perform_at(8.hours.from_now, user.id, first_attempt, CURRENT_TIME)
        next
      end
    end
  end
end