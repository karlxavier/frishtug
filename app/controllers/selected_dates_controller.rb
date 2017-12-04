class SelectedDatesController < ApplicationController
  before_action :set_date
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

  def set_date
    @date = params[:date]
  end

  def generate_date_names
    generate_dates_not_in_saturdays.map { |d| d.strftime('%A') }
  end

  def generate_dates_not_in_saturdays
    dates = (@date..(@date + 5.days)).inject([]) do |arr, d|
      arr << d unless d.saturday?
      arr
    end
    dates.pop if dates.length > 5
    dates
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