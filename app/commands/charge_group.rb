class ChargeGroup
  prepend SimpleCommand
  BLACKOUT_DATES = BlackoutDate.pluck_dates.map { |d| Time.zone.parse(d).to_date }.freeze

  def initialize(user, order)
    @user = user
    @order = order
  end

  def call
    return false if BLACKOUT_DATES.include?(order.placed_on.to_date)
    return false unless order.present?
    charge!
  end

  private

  attr_reader :user, :order

  def charge!
    return false unless user.in_a_group?
    return false if user.is_entitled_for_discount?
    return false if order.shipping_charge.present?
    charge = StripeCharger.new(user, 5)
    response = charge.charge_shipping
    if response
      return order.create_shipping_charge!(charge_id: response.id)
    else
      errors.add(:charge, charge.errors)
    end
  end
end