class Api::V1::IsPastController < Api::V1::BaseController
  before_action :set_current_time
  def index
    render json: { status: 'success', message: past_noon? }, status: :ok
  end

  private

  def set_current_time
    @current_time = Time.current
  end

  def past_noon?
    closed_time = Time.zone.parse '11:00 am'
    @current_time >= closed_time
  end
end