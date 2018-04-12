class MonthScheduler < ScheduleMaker
  def initialize(user)
    @user = user
    @last_five_orders = user.orders.active_orders.last(5)
    @schedule = user.schedule.try(:option)
    @orders = user.orders.processing
  end

  def create_full_month!
    generate_schedule(20)
  end
end