class MonthScheduler < ScheduleMaker
  def create_full_month!
    generate_schedule
  end

  def create_new_full_month!
    @subscription_start = user.subscription_expires_at + 1.day
    generate_schedule
  end
end