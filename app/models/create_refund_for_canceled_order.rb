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

  def tax_and_excess_refundable_amount
    order.ledgers.paid.where(charge_id: order.charge_id).map(&:amount).inject(:+)
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

    total = 0
    create_tax_and_excess_refund if order.charge_id.present?

    total = if order.sub_total > user.plan.limit
              user.plan.limit
            else
              order.sub_total
            end

    pending_credit = user.pending_credits
                         .where(placed_on_date: order.placed_on, charge_id: subscription_invoice.response.charge).first_or_create

    unless pending_credit.refunded?
      pending_credit.update_attributes(
        amount: total,
        activation_date: Time.current,
        remarks: "Credit from order date #{order.placed_on&.strftime("%B %d, %Y")}",
      )
    end
  end

  def create_tax_and_excess_refund
    pending_credit = user.pending_credits
                         .where(placed_on_date: order.placed_on, charge_id: order.charge_id).first_or_create

    unless pending_credit.refunded?
      pending_credit.update_attributes(
        amount: tax_and_excess_refundable_amount,
        activation_date: Time.current,
        remarks: "Additional and tax credit from order date #{order.placed_on.strftime("%B %d, %Y")}",
      )
    end
  end

  def start_worker
    CanceledOrderWorker.perform_at(user.subscribe_at, order.id)
  end
end
