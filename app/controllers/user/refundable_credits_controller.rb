class User::RefundableCreditsController < User::BaseController
  before_action :set_pending_credit, only: :update
  def index
    @refundables = current_user.pending_credits.pending_refund.page(params[:page]).per(10)
  end

  def update
    if check_available_amount_to_refund
      charge = @pending_credit.charge_id
    begin
      charge = @pending_credit.order_charge_id
    end

    Stripe::Refund.create(
      charge: charge,
      amount: to_cents(@pending_credit.amount)
    )
    @pending_credit.refunded!
    redirect_back fallback_location: :back, notice: 'Refund successful'
  rescue => e
    flash[:error] = e
    redirect_back fallback_location: :back
  end

  private

  def set_pending_credit
    @pending_credit = PendingCredit.find(params[:id])
  end

  def to_cents(amount)
    (amount.to_f * 100).to_i
  end

  def check_available_amount_to_refund
    res = Stripe::Charge.retrieve(@pending_credit.charge_id)
    total = res.amount - res.amount_refunded
    total >= to_cents(@pending_credit.amount)
  end
end