class Admin::DashboardController < Admin::BaseController
  before_action :set_date

  def index
    @order_query = OrderQuery.new(range, locations, meal_ids.compact.flatten)
  end

  private

  def range
    DateRange.new(@date.beginning_of_day, @date.end_of_day)
  end

  def set_date
    @date = Date.parse(params[:date]) rescue Date.current
  end

  def locations
    array_of_locations = params[:location]&.split(',')  || []
    array_of_locations << search_term_for_location
    array_of_locations.flatten
  end

  def meal_ids
    get_meal_ids << meal
  end

  def meal
    params[:meal]&.split(',')
  end

  def search_term_for_location
    params[:search_term_for_location]&.split(',') || []
  end

  def get_meal_ids
    Menu.search(params[:search_term_for_menus]).map(&:id)
  end
end
