class Api::V1::BaseController < ApplicationController
  protect_from_forgery with: :null_session
  rescue_from ActiveRecord::RecordNotFound, with: :not_found
  rescue_from ActiveRecord::RecordInvalid, with: :unprocessable_entity
  before_action :destroy_session

  private

  def unprocessable_entity(e)
    render json: e.record.errors, status: :unprocessable_entity
  end

  def not_found(e)
    render json: { error: e.message }, status: :not_found
  end

  def destroy_session
    request.session_options[:skip] = true
  end
end