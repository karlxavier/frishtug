class User::PlansController < User::BaseController
  def index
    @plan = current_user.plan
    render json: {
      data: @plan
    }, status: :ok
  end
end