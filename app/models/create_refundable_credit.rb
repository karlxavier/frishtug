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

  def limit
    user.plan.limit
  end

  def total
    limit > order.total_price ? limit : order.total_price
  end

  def refundable_amount
    total - current_total
  end

  def create_a_refund
    pending_credit = user.pending_credits.
      where(placed_on_date: order.placed_on, order_id: nil).first_or_create

    pending_credit.update_attributes(
      amount: refundable_amount,
      activation_date: Time.current,
      charge_id: order.charge_id
    )
  end
end