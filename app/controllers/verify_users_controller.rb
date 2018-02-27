class VerifyUsersController < ApplicationController
  def verify
    if User.exists?(email: email)
      render json: { status: 'error', message: 'Email already exists!' }, status: :ok
    else
      render json: { status: 'success', message: 'Email is available!' }, status: :ok
    end
  end

  private

  def email
    params[:email]
  end
end