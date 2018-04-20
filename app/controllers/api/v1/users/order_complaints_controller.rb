class Api::V1::Users::OrderComplaintsController < Api::V1::Users::BaseController
  def create
    if order
      order.create_comment!(comment_params)
      render json: {
        status: 'success',
        message: 'Sucessfully sent complaint.'
      }
    else
      render json: {
        status: 'error',
        message: 'Order not found for order_id'
      }, status: :unprocessable_entity
    end
  end

  private

  def order
    Order.find(params[:order_id])
  end

  def comment_params
    {
      body: params[:message],
      user_id: current_user.id
    }
  end
end