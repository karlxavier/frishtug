class ChargeGroup
  prepend SimpleCommand

  def initialize(user, order)
    @user = user
    @order = order
  end

  def call
    return false unless order.present?
    charge!
  end

  private

  attr_reader :user, :order

  def charge!
    return false unless user.in_a_group?
    return false if user.is_entitled_for_discount?
    return false if order.shipping_charge?
    charge = StripeCharger.new(user, 5)
    if charge.charge_shipping
      return order.create_shipping_charge!(charge_id: charge.id)
    else
      errors.add(:charge, charge.errors)
    end
  end
end