class UserRegistrationsController < ApplicationController
  before_action :set_allowed_zip
  require 'date_helpers/weeks'
  respond_to :js, except: :index
  respond_to :json, only: %i[selected_date days]
  SATURDAY = 6

  def index
    @registration = RegistrationForm.new
    @categorized_menus = MenuCategory.published_menus
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

  def selected_date
    return nil unless params[:date]
    verify_date(params[:date])
    date = Date.parse(params[:date])
    @dates = (date..(date + 4.days)).map { |d| d if d.wday != SATURDAY }.compact
    @dates.push(@dates.last + 1.day).compact if @dates.length < 5
    @date_names = @dates.map { |d| d.strftime('%A') }
  end

  def days
    @date = Date.current
    @date = Date.parse(params[:date]) if params[:date].present?
    render json: {
      month: @date.strftime('%B %Y'),
      next_month: @date.next_month,
      prev_month: @date.prev_month,
      days: DateHelpers::Weeks.new(@date).full_month_weeks
    }
  end

  def is_past_noon
    render json: { is_past: !past_noon?(DateTime.current) }
  end

  private

  def verify_date(date)
    date = Date.parse(date)
    @errors = []
    @errors.push 'We cant deliver after 12:00 pm.' if past_noon?(date)

    @errors.push 'We cant travel back in time.' if past_date?(date)

    @errors.push 'We are closed on saturdays.' if date.saturday?
  end

  def past_date?(date)
    date < Date.current
  end

  def past_noon?(date)
    closed_time = Time.zone.parse '11:00 am'
    date.today? && Time.current >= closed_time
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
            orders: [:order_date, menu_ids: []],
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
    @allowed_zip_codes = AllowedZipCode.all.map(&:zip)
  end
end
