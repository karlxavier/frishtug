class User::DashboardController < User::BaseController
  CURRENT_TIME = Time.current.freeze

  def index
    @todays_order = current_user.orders.placed_between?(range)
    set_scanovator
  end

  private

  def range
    DateRange.new(CURRENT_TIME.beginning_of_day, CURRENT_TIME.end_of_day)
  end

  def set_scanovator
    @scanovator = NullScanovator.new
    if @todays_order.present?
      @scanovator = ScanovatorApi.fetch @todays_order.first.id
    end
  end
end
