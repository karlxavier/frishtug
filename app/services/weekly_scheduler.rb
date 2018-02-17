class WeeklyScheduler
  WDAYS = %w[sunday monday tuesday wednesday thursday friday].freeze

  def initialize(user)
    @last_five_orders = user.orders.active_orders.first(5)
    @schedule = user.schedule.try(:option)
    @orders = user.orders.processing
  end

  def create_schedule!
    generate_schedule
  end

  def create_schedule_for_selection!
    create_selection_from(generate_schedule)
  end

  def get_schedules_for_selection!
    @orders.order(placed_on: :asc).in_groups_of(5).map do |o|
      o = o.compact
      if o.count == 5
        [
          "#{format_date(o.first&.placed_on)} - #{format_date(o.last&.placed_on)}",
          o.map(&:id).join(',')
        ]
      end
    end
  end

  private

  attr_accessor :last_five_orders, :schedule

  def last_first_order_placed_on_date
    last_five_orders.first.placed_on.to_date
  end

  def generate_schedule
    last_order = last_first_order_placed_on_date
    date = last_order.next_week(WDAYS[last_order.wday].to_sym)
    results = []
    date -= 1.days
    (0..14).map do |i|
      date += 1.days
      date += 1.days if date.saturday?
      date += 1.days if date.sunday? && schedule == 'monday_to_friday'
      date += 2.days if date.friday? && schedule == 'sunday_to_thursday'
      results << date
    end
    results
  end

  def create_selection_from(results)
    results.in_groups_of(5).map do |r|
      ["#{format_date(r.first)} - #{format_date(r.last)}", r.join(',')]
    end
  end

  def format_date(date)
    date.strftime('%b %d')
  end
end
