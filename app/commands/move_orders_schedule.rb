class MoveOrdersSchedule
  prepend SimpleCommand
  ORDER_STATUSES_TO_SKIP = [
    "completed",
    "fullfilled",
    "failed",
    "refunded"
  ].freeze

  def initialize(user)
    @user = user
    @orders = user.orders
    @schedules ||= MonthScheduler.new(user).create_full_month!
  end

  def call
    move_order_schedule!
  end

  private

  attr_accessor :orders, :user, :schedules

  def move_order_schedule!
    orders.each_with_index do |order, index|
      next if ORDER_STATUSES_TO_SKIP.include?(order.status)
      move_order(order, index)
    end
  end

  def move_order(order, index)
    order.update_attributes(placed_on: schedules[index])
  end
end