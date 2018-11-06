# frozen_string_literal: true

class CreateRefundableCredit
  attr_reader :user, :order

  def initialize(order)
    @order = order
    @user = order.user
  end

  def process
    return create_refund_for_single_order unless user.subscribed? 
    create_a_refund if valid?
  end

  private

  def valid?
    return false if order.charge_id.nil?
    return false unless order.total_price > current_total
    true
  end

  def current_total
    OrderCalculator.new(order).total
  end

  def total_refundable_amount
    order.ledgers.paid.where(charge_id: order.charge_id).map(&:amount).inject(:+)
  end

  def limit
    user.plan.limit
  end

  def total
    limit > order.total_price ? limit : order.total_price
  end

  def refundable_amount
    refund_total = total - current_total
    if refund_total > total_refundable_amount
      total_refundable_amount
    else
      refund_total
    end
  end

  def create_a_refund
    return if refundable_amount <= 0
    create_refund(refundable_amount)
  end

  def bill_history_total
    order.bill_histories.last&.amount_paid || 0
  end

  def create_refund_for_single_order
    refund_amount = bill_history_total - current_total
    return if refund_amount <= 0
    create_refund(refund_amount)
  end

  def create_refund(amount_to_refund)
    pending_credit = user.pending_credits
                         .where(placed_on_date: order.placed_on, charge_id: order.charge_id).first_or_create

    unless pending_credit.refunded?
      pending_credit.update_attributes(
        amount: amount_to_refund,
        activation_date: Time.current,
        remarks: "Credit from order date #{order.placed_on.strftime('%B %d, %Y')}"
      )
    end
    order.update_attributes(total_price: current_total)
  end
end
