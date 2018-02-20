class UserRegistrationsController < ApplicationController
  before_action :user_exists?
  before_action :set_allowed_zip, :set_tax, :set_plan, :set_dates, only: :index
  require 'date_helpers/weeks'
  respond_to :js, except: :index
  SATURDAY = 6

  def index
    @registration = RegistrationForm.new
    @categorized_menus = MenuCategory.published_menus
    @menus_with_category = Menu.group_by_category_names
    @plans = Plan.all.sort
    fresh_when etag: [
      @registration,
      @menus_with_category,
      @plans,
      @allowed_zip_codes,
      @tax_rate,
      @dates,
      @plan
    ]
  end

  def create
    @registration = RegistrationForm.new(registration_params)
    if @registration.save
      flash[:success] = 'Registration successful.'
      @message = 'success'
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

  def set_dates
    @date = Time.current
    @earliest_monday = @date.sunday? ? (@date +1.day).next_week(:monday) : @date.next_week(:monday)
    @earliest_sunday = next_sunday
  end

  def next_monday_if_past_noon
    @date >= closed_time ? @date.next_week(:monday) : @date
  end

  def next_sunday_if_past_noon
    @date >= closed_time ? @date + 7.days : @date
  end

  def closed_time
    Time.zone.parse '11:00 am'
  end

  def next_sunday
    days_to_add = 7 - @date.wday
    return @date + days_to_add.days if days_to_add > 0
    @date.next_week(:sunday)
  end

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

  def set_allowed_zip
    @allowed_zip_codes = AllowedZipCode.pluck(:zip)
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
