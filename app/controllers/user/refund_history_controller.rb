class User::RefundHistoryController < User::BaseController
  def index
    @refunds = current_user.pending_credits.refunded.page(params[:page]).per(15)
  end
end
