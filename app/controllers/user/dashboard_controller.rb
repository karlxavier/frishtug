class User::DashboardController < User::BaseController
  CURRENT_TIME = Time.current.freeze

  def index
    @todays_order = current_user.orders.placed_between?(range)
    set_scanovator
    check_and_charge_group
  end

  private

  def range
    DateRange.new(CURRENT_TIME.beginning_of_day, CURRENT_TIME.end_of_day)
  end

  def set_scanovator
    if @todays_order.present?
      @scanovator = ScanovatorApi.fetch @todays_order.first.id
      @scanovator = NullScanovator.new if @scanovator.state == 'fail'
    else
      @scanovator = NullScanovator.new
    end
  end

  def check_and_charge_group
    command = ChargeGroup.call(current_user, @todays_order.first)
    if command.success? && command.result != false
      flash[:notice] = "You have #{current_user.total_members + 1} people in your group. You will be charge additional $5 for shipping."
    end
  end
end
