class Api::V1::Users::OrdersController < Api::V1::Users::BaseController
  def index
    @orders = current_user.orders
    render jsonapi: @orders
  end
end