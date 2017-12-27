class User::ComplaintsController < User::BaseController
  def create
    order.create_comment!(body: params[:body], user_id: current_user.id)
    redirect_back fallback_location: :back, notice: 'Successfuly sent complaint.'
  end

  private

  def order
    Order.find(params[:order_id])
  end
end
