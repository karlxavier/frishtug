class ScheduleMaker
  WDAYS = %w[sunday monday tuesday wednesday thursday friday].freeze

  def initialize(user)
    @user = user
    @schedule = user.schedule.try(:option)
    @subscription_start = user.subscribe_at
    @subscription_end = user.subscription_expires_at
    @orders = user.orders.processing
  end

  private

  attr_accessor :schedule, :user, :subscription_start

  def start_date
    return subscription_start if subscription_start.present?
    user.last(20).first.placed_on
  end

  def generate_schedule(days = 20)
    date = start_date.to_date
    results = []
    (1..days).map do |i|
      date = ScheduleGenerator.new(date, schedule).generate
      results << date
      date += 1.day
    end
    results
  end
end
