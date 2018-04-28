class TaxChargeWorker
  include Sidekiq::Worker

  def perform(user_id, tax_amount)
    user = User.find(user_id)
    charge = StripeCharger.new(user, tax_amount.to_d)
    if charge.charge_tax!
      user.bill_histories.create!(
        amount_paid: tax_amount,
        description: "Tax Charge!",
        billed_at: Time.current
      )
    end
  end
end