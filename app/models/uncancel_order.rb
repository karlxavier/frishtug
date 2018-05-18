class UncancelOrder
  def initialize(order, user)
    @order = order
    @user = user
  end

  def run
    if @order.update_column(:status, :processing)
      pending_credits = PendingCredit.where(order_id: @order.id)
      pending_credits.map { |c| c.destroy }
      true
    end
  end

  private

  def next_months_first_day
    Time.current.next_month.beginning_of_month
  end
end