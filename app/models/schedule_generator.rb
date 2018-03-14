class ScheduleGenerator
  SCHEDULES = {
    monday_to_friday: 0,
    sunday_to_thursday: 5,
    null_param: 6
  }.freeze

  def initialize(date, schedule)
    @schedule = schedule
    @schedule_to_skip = SCHEDULES[schedule.to_sym]
    @date = date
  end

  def generate
    @date = skip_saturdays
    @date = skip_not_in_schedule
    @date
  end

  private

  attr_accessor :date, :schedule_to_skip, :schedule

  def skip_not_in_schedule
    if date.wday == schedule_to_skip
      ScheduleGenerator.new(date + 1, schedule).generate
    else
      date
    end
  end

  def skip_saturdays
    if date.saturday?
      ScheduleGenerator.new(date + 1, schedule).generate
    else
      date
    end
  end
end