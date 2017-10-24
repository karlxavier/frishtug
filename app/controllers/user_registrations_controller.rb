class UserRegistrationsController < ApplicationController
  respond_to :js, except: :index

  def index
    @registration = RegistrationForm.new
  end

  def create
    @registration = RegistrationForm.new(registration_params)
    if @registration.save
      flash[:success] = 'Registration successful.'
      @message = 'success'
    end
    respond_with(@registration)
  end

  private

  def registration_params
    params.fetch(:registration_form, {})
          .permit(
            :first_name,
            :last_name,
            :email,
            :password,
            :line1,
            :line2,
            :front_door,
            :city,
            :state,
            :zip_code,
            :group_code
          )
  end
end
