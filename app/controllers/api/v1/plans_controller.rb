class Api::V1::PlansController < Api::V1::BaseController
  def index
    plans = Plan.all.sort
    render jsonapi: plans
  end
end