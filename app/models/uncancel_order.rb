# frozen_string_literal: true

class UncancelOrder
  def initialize(order, user)
    @order = order
    @user = user
  end

  def run
    if @order.update_column(:status, :awaiting_shipment)
      pending_credits = @user.pending_credits.where(order_id: @order.id)
      total = 0
      pending_credits.each do |credit|
        charge_id = credit.charge_id
        if credit.refunded?
          total += credit.amount
          @order.bill_histories.where(charge_id: charge_id).first.destroy
        end
        credit.destroy
      end
      ChargeUser.call(@order, @user) if total > 0
      true
    end
  end

  private

  def next_months_first_day
    Time.current.next_month.beginning_of_month
  end
end
