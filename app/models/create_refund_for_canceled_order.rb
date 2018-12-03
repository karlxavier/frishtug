# frozen_string_literal: true

class CreateRefundForCanceledOrder
  attr_reader :order, :user

  def initialize(order, user)
    @order = order
    @user = user
  end

  def process
    return false unless order.cancelled?
    if user.subscribed?
      create_a_refund_for_subscribed_user
    else
      create_a_refund
    end
  end

  private

  def subscription_invoice
    SubscriptionInvoice.new(user).get_invoice
  end

  def pending_payments
    order.ledgers.where(status: %i[pending_payment payment_failed])
  end

  def pending_payments_total
    pending_payments.pluck(:amount).inject(:+) || 0
  end

  def create_a_refund
    charge_ids = order.bill_histories.pluck(:charge_id)
    charge_ids.each do |id|
      next if id.nil?
      response = Stripe::Charge.retrieve(id)
      pending_credit = user.pending_credits
                           .where(placed_on_date: order.placed_on, charge_id: id).first_or_create

      next if pending_credit.refunded?
      next if response.refunded

      pending_credit.update_attributes(
        amount: (response.amount / 100.0).to_d,
        activation_date: Time.current,
        remarks: "Credit from order date #{order.placed_on&.strftime("%B %d, %Y")}",
      )
    end
  rescue StandardError => e
    false
  end

  def create_a_refund_for_subscribed_user
    return start_worker unless subscription_invoice.success
    total = order.total - pending_payments_total

    pending_credit = user.pending_credits
                         .where(placed_on_date: order.placed_on, charge_id: subscription_invoice.response.charge).first_or_create

    unless pending_credit.refunded?
      pending_credit.update_attributes(
        amount: total,
        activation_date: Time.current,
        remarks: "Cancelled credit from order date #{order.placed_on&.strftime("%B %d, %Y")}",
      )
      cancel_pending_payments
    end
  end

  def start_worker
    CanceledOrderWorker.perform_async(order.id)
  end

  def cancel_pending_payments
    pending_payments.map { |l| l.cancelled! }
  end
end
