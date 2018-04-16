class Api::V1::Users::AuthenticateController < Api::V1::Users::BaseController
  skip_before_action :authenticate_request

  def create
    command = AuthenticateUser.call(email, password)
    if command.success?
      render json: { status: 'success', auth_token: command.result }, status: :ok
    else
      render json: { status: 'error', message: command.errors }, status: :unauthorized
    end
  end

  private

  def password
    params[:password]
  end

  def email
    params[:email]
  end
end