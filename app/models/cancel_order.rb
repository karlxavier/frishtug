# frozen_string_literal: true

class CancelOrder
  def initialize(order, user)
    @order = order
    @user = user
  end

  def run
    if @order.cancelled!
      CreateRefundForCanceledOrder.new(@order, @user).process
      true
    end
  end
end
