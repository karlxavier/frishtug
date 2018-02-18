class PastNoonsController < ApplicationController
  before_action :set_current_time
  def index
    render json: { is_past: past_noon? }
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