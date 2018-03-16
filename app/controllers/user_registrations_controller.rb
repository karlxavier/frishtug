class UserRegistrationsController < ApplicationController
  ACTIONS = %i[set_tax set_plan].freeze
  before_action :user_exists?
  before_action *ACTIONS, only: :index
  require 'date_helpers/weeks'
  respond_to :js, except: :index
  SATURDAY = 6

  def index
    @registration = RegistrationForm.new
    @menus_with_category = ItemsWithStock.grouped(:menu_category_name)
    @plans = Plan.all.sort
  end

  def create
    @registration = RegistrationForm.new(registration_params)
    if @registration.save
      sign_in(User.find_by_email(@registration.email), scope: :user)
    end
    respond_with(@registration)
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
            orders: [:order_date, menu_ids: [], quantities: [], add_ons: [:ids]],
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

  def set_date
    @date = params[:date]
  end

  def user_exists?
    redirect_to root_url, notice: 'Already signed up' if current_user
  end

  def set_tax
    @tax_rate = Store.first.tax.rate
  end

  def set_plan
    plan_name = params[:plan_name]
    @plan = Plan.find_by_name(plan_name) if plan_name
  end
end
