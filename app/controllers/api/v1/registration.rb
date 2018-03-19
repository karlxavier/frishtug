class Api::V1::RegistrationController < Api::V1::BaseController
  def create
    @registration = RegistrationForm.new(registration_params)
    if @registration.save
      sign_in(User.find_by_email(@registration.email), scope: :user)
    end
  end
end