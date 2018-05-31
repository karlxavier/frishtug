class RecordLedger
  def initialize(user, order)
    @user = user
    @order = order
  end

  def record!
    record_tax(calculate_tax)
    record_excess(calculate_excess)
    true
  end

  private

  attr_reader :user, :order

  def calculate_tax
    CalculateAmount.call(user, order, 'tax').result
  end

  def calculate_excess
    CalculateAmount.call(user, order, 'excess').result
  end

  def record_tax(amount)
    return if amount <= 0
    tax_record = user.tax_ledgers.where(order_id: order.id, status: %i[pending_payment payment_failed]).first

    tax_record = user.tax_ledgers.create(order_id: order.id, status: :pending_payment) unless tax_record.present? 

    tax_record.update_attributes(amount: amount)
  end

  def record_excess(amount)
    return if amount <= 0
    excess_record = user.excess_ledgers.where(order_id: order.id, status: %i[pending_payment payment_failed]).first

    excess_record = user.excess_ledgers.create(order_id: order.id, status: :pending_payment) unless excess_record.present? 

    excess_record.update_attributes(amount: amount)
  end
end