class User::UserInformationController < User::BaseController
  def index
    @user_json = current_user.to_json(except: [:created_at, :updated_at])
    @user_phone_number = current_user.contact_number.phone_number
  end

  def create
    @user = User.find(current_user.id)
    if @user.update_attributes(user_params)
      flash[:success] = 'User information updated!'
      redirect_back fallback_location: :back
    else
      flash[:error] = 'User information failed to update'
      redirect_back fallback_location: :back
    end
  end

  private

    def user_params
      params.fetch(:user, {}).permit(:first_name, :last_name, :email, contact_number_attributes: [ :phone_number ])
    end
end
