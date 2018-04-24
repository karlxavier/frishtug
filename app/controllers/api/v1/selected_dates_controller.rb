class Api::V1::SelectedDatesController < Api::V1::BaseController
  before_action :set_date, :set_schedule_to_skip
  SATURDAY = 6.freeze
  def index
    @date = Date.parse(@date)
    verify_date
    if @errors.any?
      render json: {
        status: 'error',
        message: @errors.join(', '),
      }, status: :ok
    else
      render json: {
        status: 'success',
        dates: generate_dates_not_in_saturdays,
        names: generate_date_names
      }, status: :ok
    end
  end

  private

  def set_schedule_to_skip
    hash = {
      monday_to_friday: 0,
      sunday_to_thursday: 5,
      null_param: 6
    }
    @sched = params[:schedule] || 'null_param'
  end

  def set_date
    @date = params[:date]
  end

  def generate_date_names
    generate_dates_not_in_saturdays.map { |d| d.strftime('%A') }
  end

  def generate_dates_not_in_saturdays
    index = 1
    dates = []
    current_date = @date
    while index <= 5 do
      current_date = ScheduleGenerator.new(current_date, @sched).generate
      dates << current_date
      current_date += 1.day
      index += 1
    end
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