class Api::V1::VerifyUsersController < Api::V1::BaseController
  before_action :check_params!
  def index
    if User.exists?(email: email)
      render json: { status: 'error', message: 'Email already exists!' }, status: :ok
    else
      render json: { status: 'success', message: 'Email is available!' }, status: :ok
    end
  end

  private

  def check_params!
    unless params[:email].present?
      render json: { error: 'Missing email parameter' }, status: :unprocessable_entity
    end
  end

  def email
    params[:email]
  end
end