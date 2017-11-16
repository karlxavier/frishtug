class Scheduler
  def initialize(type)
    @type = type
    @start_date = nil
    @end_date = nil
    @date = Date.today
  end

  def run
    send("#{@type}_schedules")
  end

  def monday_schedules
    @start_date = @date.monday? ? @date : @date.next_week(:monday)
    @end_date = start_date + 30.days
    day_reducer(1)
  end

  def sunday_schedules
    @start_date = @date.sunday? ? @date : @date.beginning_of_week(:sunday).next_week(:sunday)
    @end_date = start_date + 30.days
    day_reducer(0)
  end

  def single_order_schedules
    @start_date = @date.monday? ? @date : @date.next_week(:monday)
    @end_date = @start_date.end_of_week
    single_order_reducer
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

    def single_order_reducer
      (start_date..end_date).reduce([]) do |array, date|
        array.push(date)
        array
      end
    end
end