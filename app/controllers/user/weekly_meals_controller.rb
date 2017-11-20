class User::WeeklyMealsController < User::BaseController
  def index
    @date = parsed_date(params[:date]) || Date.current
    @active_weeks = current_user.orders.map {|o| o.placed_on.strftime('%Y-%m-%d')}
    @orders = current_user.orders.this_week
  end

  private

  def parsed_date(date)
    return nil unless date
    Date.parse(date)
  end
end
