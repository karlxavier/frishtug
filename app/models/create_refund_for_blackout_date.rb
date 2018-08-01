class CreateRefundForBlackoutDate
  BLACKOUT_DATES = BlackoutDate.pluck_dates.freeze
  attr_reader :order, :user
  
  def initialize(order)
    @order = order
    @user = order.user
  end

  def process
    if valid?
      return create_a_refund
    end
  end

  private

  def valid?
    return false unless user.subscribed?
    return false if total <= 0
    return false unless BLACKOUT_DATES.include?(order.placed_on&.strftime('%B %d'))
    true
  end

  def total
    OrderCalculator.new(order).total
  end

  def retrieve_invoice
    Stripe::Invoice.all(customer: user.stripe_customer_id, limit: 100).data.
      keep_if { |s| s[:subscription] == user.stripe_subscription_id }.first
  end

  def create_a_refund
    pending_credit = user.pending_credits.where(placed_on_date: order.placed_on).first_or_create

    if retrieve_invoice.nil?
      CreateBlackoutRefundWorker.perform_at(user.subscribe_at, order.id)
      return
    end

    unless pending_credit.refunded?
      pending_credit.update_attributes(
        amount: total,
        activation_date: user.orders.first.placed_on + 28.days,
        charge_id: retrieve_invoice.charge,
        remarks: "Black-out date #{order.placed_on&.strftime('%B %d, %Y')}"
      )
    end
  end
end