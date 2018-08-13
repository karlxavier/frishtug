class User::ChangePasswordController < User::BaseController
  def index
    @user_json = current_user.to_json(except: [:created_at, :updated_at])
  end

  def create
    @user = current_user
    if @user.valid_password?(user_params[:password])
      @user.update_attributes(password: user_params[:confirm_password])
      sign_in(@user, scope: :user, bypass: true)
      render json: {status: "success", message: "Password updated!"}, status: :ok
    else
      render json: {status: "error", message: "Old password does not match"}, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.fetch(:user, {}).permit(:password, :new_password, :confirm_password)
  end
end
