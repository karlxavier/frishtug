class User::RefundableCreditsController < User::BaseController
  before_action :is_subscribed?
  before_action :set_pending_credit, only: :update
  def index
    @refundables = current_user.pending_credits
  end

  def update
    Stripe::Refund.create(
      charge: @pending_credit.charge_id,
      amount: to_cents(@pending_credit.amount)
    )
    @pending_credit.destroy
    redirect_back fallback_location: :back, notice: 'Refund successful'
  rescue => e
    flash[:error] = e.message
    redirect_back fallback_location: :back
  end

  private

  def is_subscribed?
    unless current_user.subscribed?
      redirect_back fallback_location: user_dashboard_index_path
    end
  end

  def set_pending_credit
    @pending_credit = PendingCredit.find(params[:id])
  end

  def to_cents(amount)
    (amount.to_f * 100).to_i
  end
end