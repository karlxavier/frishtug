class User::ChangePasswordController < User::BaseController
  def index
    @user_json = current_user.to_json(except: [:created_at, :updated_at])
  end

  def create
    @user = current_user
    if @user.valid_password?(user_params[:old_password])
      @user.update_attribues(password: user_params[:confirm_password])
      flash[:success] = 'Password changed!'
      redirect_back fallback_location: :back
    else
      flash[:error] = 'Old password does not match'
      redirect_back fallback_location: :back
    end
  end

  private

    def user_params
      params.fetch(:user, {}).permit(:old_password, :new_password, :confirm_password)
    end
end
