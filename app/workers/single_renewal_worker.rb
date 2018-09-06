class SingleRenewalWorker
  include Sidekiq::Worker
  CURRENT_TIME=Time.current.freeze

  def perform(user_id, attempt)
    user = User.find(user_id)

    if attempt > 3
      remove_referrer(user)
      remove_candidate(user)
      user.update_attributes(
        stripe_subscription_id: nil,
        subscribe_at: nil,
        plan_id: Plan.where(interval: [nil, ''], for_type: 'individual').take.id)
    end

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

      SubscriptionFailedMailer.notify(user_id: user.id, error_message: e.message, attemt_time: attempt_time).deliver
      SingleRenewalWorker.perform_at(attempt_time, user.id, attempt)
    end
  end

  private
  def remove_referrer(current_user)
    if current_user.referrer?
      current_user.referrer.destroy
    end
  end

  def remove_candidate(current_user)
    if current_user.candidate?
      current_user.candidate.destroy
    end
  end
end