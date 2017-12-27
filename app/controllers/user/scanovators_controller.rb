class User::ScanovatorsController < User::BaseController
  respond_to :js, only: :index

  def index
    @response = ScanovatorApi.fetch(params[:order_id])
    @response = NullScanovator.new if @response.state == 'fail'
    respond_with(@response)
  end
end
