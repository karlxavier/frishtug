class UserRegistrationsController < ApplicationController
  respond_to :js, except: :index

  def index
    @registration = RegistrationForm.new
    @categorized_menus = MenuCategory.published_menus
  end

  def create
    @registration = RegistrationForm.new(registration_params)
    if @registration.save
      flash[:success] = 'Registration successful.'
      @message = 'success'
    end
    respond_with(@registration)
  end

  def schedule
    type = :monday
    type = :sunday if params[:type] == 'sunday_to_thursday'
    @schedule = Scheduler.new(type).run
  end

  def payment_method; end

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
            :group_code,
            :phone_number,
            :plan_id,
            :card_number,
            :month,
            :year,
            :cvc,
            :bank_name,
            :routing_number,
            :account_number,
            :start_date,
            :location_at,
            :schedule,
            :payment_method,
            :billing_line_1,
            :billing_line_2,
            :billing_city,
            :billing_state,
            :billing_zip_code,
            :billing_phone_number,
            orders: [:order_date, menu_ids: []]
          )
  end
end
