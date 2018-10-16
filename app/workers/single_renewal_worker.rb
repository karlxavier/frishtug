class SingleRenewalWorker
  include Sidekiq::Worker

  def perform(user_id, attempt, time)
    current_time = Time.zone.parse(time)
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
    plan_id = user.plan_id
    renewal = RenewSubscription.call(user: user, time: current_time)

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
      attempt += 1
      attempt_time = case attempt
      when 1..2
        4.hours.from_now
      when 3
        8.hours.from_now
      end

      SubscriptionFailedMailer.notify(user_id: user.id, error_message: e.message, attemt_time: attempt_time).deliver
      SingleRenewalWorker.perform_at(attempt_time, user.id, attempt, current_time)
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