class ExcessChargeWorker
  include Sidekiq::Worker

  def perform(user_id, excess_amount)
    user = User.find(user_id)
    charge = StripeCharger.new(user, excess_amount.to_d)
    if charge.charge_excess!
      user.bill_histories.create!(
        amount_paid: excess_amount,
        description: "Excess Charge!",
        billed_at: Time.current
      )
    end
  end
end