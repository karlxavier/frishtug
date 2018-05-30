class PendingExcessCharge < PendingCharge
  belongs_to :user
  after_save :check_and_charge

  private

  def check_and_charge
    excess_charge = PendingExcessCharge.where(user_id: self.user_id)
    total_amount = excess_charge.pluck(:amount).inject(:+)
    description = excess_charge.pluck(:remarks).join(", ")
    if total_amount >= 0.50
      Stripe::Charge.create(
        amount: (total_amount.to_r * 100).to_i,
        currency: 'usd',
        customer: self.user.stripe_customer_id,
        description: description
      )
    end
  end
end