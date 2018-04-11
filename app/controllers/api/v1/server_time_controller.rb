class Api::V1::ServerTimeController < Api::V1::BaseController
  def index
    render json: { status: 'success', data: Time.current }, status: :ok
  end
end