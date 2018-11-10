# frozen_string_literal: true

class RecordLedger
  def initialize(user, order)
    @user = user
    @order = order
  end

  def record!(notify_user: false)
    record_both_tax_and_excess
    send_notification if notify_user == true
    true
  rescue => e
    false
  end

  def record_shipping!
    return unless @user.plan.party_meeting?
    send_notification if record_shipping_charge
  rescue => e
    false
  end

  private

  attr_reader :user, :order

  def send_notification
    PendingChargeMailer.notify(user_id: user.id, order_id: order.id).deliver
  end

  def record_both_tax_and_excess
    tax = calculate_tax
    excess = calculate_excess
    record_tax(tax)
    record_excess(excess)

    if tax > 0 || excess > 0
      order.pending_payment!
    else
      order.update_columns(status: :awaiting_shipment)
    end
  end

  def calculate_tax
    CalculateAmount.call(user, order, "tax").result
  end

  def calculate_excess
    CalculateAmount.call(user, order, "excess").result
  end

  def record_tax(amount)
    tax_record = user.tax_ledgers.where(order_id: order.id, status: %i[pending_payment payment_failed]).first

    tax_record = user.tax_ledgers.create(order_id: order.id, status: :pending_payment) unless tax_record.present?

    tax_record.update_attributes(amount: amount)
  end

  def record_excess(amount)
    excess_record = user.additional_ledgers.where(order_id: order.id, status: %i[pending_payment payment_failed]).first

    excess_record = user.additional_ledgers.create(order_id: order.id, status: :pending_payment) unless excess_record.present?

    excess_record.update_attributes(amount: amount)
  end

  def record_shipping_charge
    shipping = ShippingPrice.find_by_zip(user.active_address.zip_code)
    return false if shipping.nil?

    shipping_record = user.shipping_charge_ledgers.where(order_id: order.id, status: %i[pending_payment payment_failed paid]).first

    shipping_record = user.shipping_charge_ledgers.create(order_id: order.id, status: :pending_payment) unless shipping_record.present?

    if shipping_record.paid?
      order.awaiting_shipment!
      return false 
    end
    shipping_record.update_attributes(amount: shipping.price)
    order.pending_payment!
    true
  end
end
