class ScheduleMaker
  WDAYS = %w[sunday monday tuesday wednesday thursday friday].freeze

  def initialize(user)
    @user = user
    @schedule = user.schedule.try(:option)
    @orders = user.orders.processing
  end

  private

  attr_accessor :schedule, :user

  def last_first_order_placed_on_date
    user.orders.active_orders.last(5).first.placed_on.to_date
  end

  def generate_schedule(days = 15)
    last_order = last_first_order_placed_on_date
    date = last_order.next_week(WDAYS[last_order.wday].to_sym)
    results = []
    (1..days).map do |i|
      date = ScheduleGenerator.new(date, schedule).generate
      results << date
      date += 1.day
    end
    results
  end
end
