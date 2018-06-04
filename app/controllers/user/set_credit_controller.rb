class User::SetCreditController < User::BaseController
  def index
    remove_pending_credit
    if pending_credit.update_attributes(order_id: order.id)
      render json: { status: "success" }, status: :ok
    else
      render json: { status: "error", message: pending_credit.errors }, status: :unprocessable_entity
    end
  end

  private

  def pending_credit
    PendingCredit.find(params[:pending_credit_id])
  end

  def order
    Order.find(params[:order_id])
  end

  def remove_pending_credit
    pending_credits = PendingCredit.where(order_id: order.id)
    if pending_credits.size > 1
      pending_credits.update_all(order_id: nil)
    end
  end
end