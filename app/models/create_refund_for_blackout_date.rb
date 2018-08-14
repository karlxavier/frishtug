# frozen_string_literal: true

class CreateRefundForBlackoutDate
  BLACKOUT_DATES = BlackoutDate.pluck_dates.freeze
  attr_reader :order, :user

  def initialize(order)
    @order = order
    @user = order.user
  end

  def process
    return create_a_refund if valid?
  end

  private

  def valid?
    return false if total <= 0
    return false unless BLACKOUT_DATES.include?(order.placed_on&.strftime("%B %d"))
    true
  end

  def total
    if user.subscribed?
      OrderCalculator.new(order).total_without_shipping
    else
      OrderCalculator.new(order).total
    end
  end

  def create_a_refund
    if user.subscribed?
      retrieve_invoice = SubscriptionInvoice.new(user).get_invoice
      unless retrieve_invoice.success
        CreateBlackoutRefundWorker.perform_at(user.subscribe_at, order.id)
        return
      end
      charge_id = retrieve_invoice.response.charge
    else
      charge_id = order.charge_id
    end

    pending_credit = user.pending_credits.where(placed_on_date: order.placed_on).first_or_create

    unless pending_credit.refunded?
      pending_credit.update_attributes(
        amount: total,
        activation_date: Time.current,
        charge_id: charge_id,
        remarks: "Black-out date #{order.placed_on&.strftime("%B %d, %Y")}",
      )
    end
  end
end
