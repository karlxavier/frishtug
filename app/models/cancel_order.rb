class CancelOrder
  def initialize(order, user)
    @order = order
    @user = user
  end

  def run
    if @order.cancelled!
      @user.pending_credits.create!(
        amount: OrderCalculator.new(@order).total,
        activation_date: next_months_first_day
      )
      true
    end
  end

  private

  def next_months_first_day
    Time.current.next_month.beginning_of_month
  end
end