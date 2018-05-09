class UserRegistrationsController < ApplicationController
  before_action :user_exists?
  before_action :set_plan, :set_group_code, only: :index
  require 'date_helpers/weeks'
  SATURDAY = 6

  def index
  end

  def create
    @registration = RegistrationForm.new(registration_params)
    if @registration.save
      sign_in(User.find_by_email(@registration.email), scope: :user)
      render json: {
        status: 'success',
        redirect_to: user_dashboard_index_path,
        group_code: current_user.referrer&.group_code
      }, status: :ok
    else
      render json: {
        status: 'error',
        message: @registration.errors.full_messages.join(', ')
      }, status: :unprocessable_entity
    end
  end

  def schedule
    type = :monday
    type = :sunday if params[:type] == 'sunday_to_thursday'
    @schedule = Scheduler.new(type).run
  end

  private

  def registration_params
    params.fetch(:registration_form, {})
          .permit(
            :first_name,
            :last_name,
            :email,
            :password,
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
            :schedule,
            :payment_method,
            :billing_line_1,
            :billing_line_2,
            :billing_city,
            :billing_state,
            :billing_zip_code,
            :billing_phone_number,
            :stripe_token,
            :card_brand,
            orders: [:order_date, menus_orders_attributes: [:id , :menu_id, :quantity, add_ons: []]],
            addresses: %i[
              line1
              line2
              front_door
              city
              state
              zip_code
              location_at
            ]
          )
  end

  def user_exists?
    redirect_to root_url, notice: 'Already signed up' if current_user
  end

  def set_plan
    plan_name = params[:plan_name]
    @plan = Plan.find_by_name(plan_name) if plan_name
  end

  def set_group_code
    @group_code = params[:group_code] if params[:group_code].present?
  end
end
