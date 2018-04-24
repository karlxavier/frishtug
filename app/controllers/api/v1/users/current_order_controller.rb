class Api::V1::Users::CurrentOrderController < Api::V1::Users::BaseController
  def index
    @order = current_user.orders.placed_between?(range)
    if @order.present?
      ChargeGroup.call(current_user, @order.first)
      render jsonapi: @order.first
    else
      render json: {
        status: 'error',
        message: "No order for today #{current_time.to_date}"
      }, status: :not_found
    end
  end

  private

  def current_time
    Time.current
  end

  def range
    DateRange.new(current_time.beginning_of_day, current_time.end_of_day)
  end
end