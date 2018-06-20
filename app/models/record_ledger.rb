class RecordLedger
  def initialize(user, order)
    @user = user
    @order = order
  end

  def record!(notify_user:)
    record_with_pending_credit if @order.pending_credit.present?
    record_both_tax_and_excess unless @order.pending_credit.present?
    send_notification if notify_user == true
    true
  rescue => e
    Rails.logger.fatal e.message
    false
  end

  private

  attr_reader :user, :order

  def send_notification
    PendingChargeMailer.notify(user_id: user.id, order_id: order.id).deliver
  end

  def record_with_pending_credit
    total = deduct_pending_credit
    if total > 0
      record_excess(total)
    end
  end

  def record_both_tax_and_excess
    tax = calculate_tax
    excess = calculate_excess
    record_tax(tax)
    record_excess(excess)

    if tax > 0 || excess > 0
      order.pending_payment!
    else
      order.update_columns(status: :processing)
    end
  end

  def deduct_pending_credit
    credit = order.pending_credit.amount
    tax = calculate_tax
    excess = calculate_excess
    tax_and_excess_total = tax + excess
    total = credit - tax_and_excess_total
    total < 0 ? total.abs : 0
  end

  def calculate_tax
    CalculateAmount.call(user, order, 'tax').result
  end

  def calculate_excess
    CalculateAmount.call(user, order, 'excess').result
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
end