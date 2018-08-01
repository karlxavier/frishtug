class CreateRefundableCredit
  attr_reader :user, :order

  def initialize(order)
    @order = order
    @user = order.user
  end

  def process
    if valid?
      create_a_refund
    end
  end

  private

  def valid?
    return false unless user.subscribed?
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
    pending_credit = user.pending_credits.
      where(placed_on_date: order.placed_on, charge_id: order.charge_id).first_or_create

    pending_credit.update_attributes(
      amount: refundable_amount,
      activation_date: Time.current,
      remarks: "Credit from order date #{order.placed_on.strftime('%B %d, %Y')}"
    )
    order.update_attributes(total_price: current_total)
  end
end