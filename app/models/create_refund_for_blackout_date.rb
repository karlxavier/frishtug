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

  def blackout_date_description
    BlackoutDate.pluck(:month, :day, :description).reduce({}) do |h, value|
      h[Time.zone.parse("#{value.first} #{value.second}").strftime('%B %d')] = value.last
      h
    end
  end

  def valid?
    return false if order_total <= 0
    return false unless BLACKOUT_DATES.include?(order.placed_on&.strftime("%B %d"))
    true
  end

  def order_total
    order.total
  end

  def create_a_refund
    if user.subscribed?
      retrieve_invoice = SubscriptionInvoice.new(user).get_invoice
      unless retrieve_invoice.success
        CreateBlackoutRefundWorker.perform_at(user.subscribe_at, order.id)
        return
      end
      charge_id = check_available_refund_amount(retrieve_invoice.response.charge)
    else
      charge_id = order.charge_id
    end

    pending_credits = user.pending_credits.where(placed_on_date: order.placed_on)

    if pending_credits.length > 1
      pending_credits.last.destroy! unless pending_credits.last.refunded?
    end

    pending_credit = pending_credits.first_or_create

    unless pending_credit.refunded?
      pending_credit.update_attributes(
        amount: order_total,
        activation_date: Time.current,
        charge_id: charge_id,
        order_charge_id: order.charge_id,
        remarks: "Black-out date #{order.placed_on&.strftime("%B %d, %Y")}, #{blackout_date_description[order.placed_on.strftime('%B %d')]}",
      )
    end
  end

  def check_available_refund_amount(charge_id)
    total_refunded = user.pending_credits.where(charge_id: charge_id, status: :refunded).pluck(:amount).inject(:+) || 0
    subscription_charge = user.plan.price
    remaining_amount = subscription_charge - total_refunded

    return charge_id if remaining_amount >= order_total
    order.charge_id
  end
end
