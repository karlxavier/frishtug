class User::ScanovatorsController < User::BaseController
  respond_to :js, only: :index

  def index
    order = Order.find(params[:order_id])
    if order.present && order.is_rollover?
      @response = ScanovatorApi.fetch(params[:order_id])
      @response = NullScanovator.new if @response.state == 'fail'
    else
      @response = NullScanovator.new
    end
    respond_with(@response)
  end
end
