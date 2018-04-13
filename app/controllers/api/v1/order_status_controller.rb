class Api::V1::OrderStatusController < Api::V1::BaseController
  before_action :set_user_current_order
  CURRENT_TIME = Time.current.freeze
  def index
    if @current_order.present?
      @scanovator = ScanovatorApi.fetch @current_order.first.id
      @scanovator = NullScanovator.new if @scanovator.state == 'fail'
      render json: {
        status: 'success',
        data: @scanovator
      }, status: :ok
    else
      render json: { status: 'error', message: 'No available order today!' }, status: 400
    end
  end

  private

  def range
    DateRange.new(CURRENT_TIME.beginning_of_day, CURRENT_TIME.end_of_day)
  end

  def set_user_current_order
    user = User.find(params[:id])
    @current_order = user.orders.placed_between?(range)
  end
end