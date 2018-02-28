class InactiveUsersController < ApplicationController
  def create
    @inactive_user = InactiveUser.new(inactive_user_params)
    if @inactive_user.save
      render json: { status: 'success', inactive_user: @inactive_user }, status: :ok
    else
      render json: {
        status: 'error',
        message: @inactive_user.errors.full_messages.join(', ')
      }, status: :unprocessable_entity
    end
  end

  private

  def inactive_user_params
    params.require(:inactive_user).permit(:first_name, :last_name, :email)
  end
end