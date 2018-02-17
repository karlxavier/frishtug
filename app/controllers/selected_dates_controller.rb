class SelectedDatesController < ApplicationController
  before_action :set_date, :set_schedule_to_skip
  SATURDAY = 6.freeze
  def index
    @date = Date.parse(@date)
    verify_date
    render json: {
      status: @errors.any? ? 'error' : 'success',
      message: @errors.any? ? @errors.join(', ') : '',
      dates: generate_dates_not_in_saturdays,
      names: generate_date_names
    }
  end

  private

  def set_schedule_to_skip
    hash = {
      monday_to_friday: 0,
      sunday_to_thursday: 5,
      null_param: 6
    }
    sched = params[:schedule] || 'null_param'
    @schedule_to_skip = hash[sched.to_sym]
  end

  def set_date
    @date = params[:date]
  end

  def generate_date_names
    generate_dates_not_in_saturdays.map { |d| d.strftime('%A') }
  end

  def generate_dates_not_in_saturdays
    index = 0
    dates = []
    current_date = @date - 1.days
    while index <= 4 do
      current_date += 1.days
      current_date = skip_saturdays(current_date)
      current_date = skip_not_in_schedule(current_date)
      dates << current_date
      index += 1
    end
    dates
  end

  def skip_saturdays(date)
    date += 1 if date.saturday?
    date
  end

  def skip_not_in_schedule(date)
    date += 1.days if date.wday == @schedule_to_skip
    skip_saturdays(date)
  end

  def verify_date
    @errors = []
    @errors.push 'We cant deliver after 12:00 pm.' if past_noon?

    @errors.push 'We cant travel back in time.' if past_date?

    @errors.push 'We are closed on saturdays.' if @date.saturday?
  end

  def past_date?
    @date < Date.current
  end

  def past_noon?
    closed_time = Time.zone.parse '11:00 am'
    @date.today? && Time.current >= closed_time
  end
end