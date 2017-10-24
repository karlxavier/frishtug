class Scheduler
  def initialize(type)
    @type = type
    @start_date = nil
    @end_date = nil
  end

  def run
    send("#{@type}_schedules", Date.today)
  end

  def monday_schedules(date)
    @start_date = date.monday? ? date : date.next_week(:monday)
    @end_date = start_date + 30.days
    day_reducer(1)
  end

  def sunday_schedules(date)
    @start_date = date.sunday? ? date : date.beginning_of_week(:sunday).next_week(:sunday)
    @end_date = start_date + 30.days
    day_reducer(0)
  end

  private

    attr_reader :start_date, :end_date

    def day_reducer(day_number)
      (start_date..end_date).reduce([]) do |array, date|
        if date.wday == day_number
          array.push(date)
        end
        array
      end
    end
end