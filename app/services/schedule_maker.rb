class ScheduleMaker
  WDAYS = %w[sunday monday tuesday wednesday thursday friday].freeze

  def initialize(user)
    @user = user
    @schedule = user.schedule.try(:option)
    @subscription_start = user.subscribe_at
    @subscription_end = user.subscription_expires_at
    @orders = user.orders
  end

  private

  attr_accessor :schedule, :user, :subscription_start

  def start_date
    return subscription_start if subscription_start.present?
    if user.orders.size % 20 == 0
      user.orders.last(20).first.placed_on
    else
      user.orders.first.placed_on
    end
  end

  def generate_schedule(days = 20, skip_active = false)
    date = start_date.to_date
    results = []
    (1..days).map do |i|
      date = ScheduleGenerator.new(date, schedule).generate
      results << date
      date += 1.day
    end
    return prune_dates(results) unless skip_active
    results
  end

  def prune_dates(dates)
    active_orders = user.orders.where.not(status: :template).pluck(:placed_on).map(&:to_date)
    pruned_dates = dates - active_orders
    
    return dates if pruned_dates.empty?
    total_iteration = 20 - pruned_dates.length
    date = pruned_dates.last + 1.day

    return dates unless total_iteration > 0
    (1..total_iteration).map do |i|
      date = ScheduleGenerator.new(date, schedule).generate
      pruned_dates << date
      date += 1.day
    end
    pruned_dates
  end
end
