class MoveOrdersSchedule
  prepend SimpleCommand
  BLACKOUT_DATES = BlackoutDate.pluck_dates.map { |d| Time.zone.parse(d) }.freeze
  ORDER_STATUSES_TO_SKIP = %i[
    completed
    fulfilled
    failed
    refunded
    template
  ].freeze

  def initialize(user)
    @user = user
    @orders = user.orders.where.not(placed_on: BLACKOUT_DATES, status: ORDER_STATUSES_TO_SKIP)
    month ||= MonthScheduler.new(user).create_full_month!
    @schedules = month - BLACKOUT_DATES.map(&:to_date)
  end

  def call
    move_order_schedule!
  end

  private

  attr_accessor :orders, :user, :schedules

  def move_order_schedule!
    schedules.length.times do |index|
      orders[index]&.update_attributes(placed_on: schedules[index])
    end
  end
end