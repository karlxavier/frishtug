class Admin::ScanovatorsController < Admin::BaseController
  before_action :set_date
  respond_to :js, only: :create
  SKIPPABLE_DATES = BlackoutDate.pluck_dates.freeze

  def index
    FetchOrdersStatus.new(params[:date]).run
    range = DateRange.new(@date.beginning_of_day, @date.end_of_day)
    order_query = OrderQuery.new(range, locations, meal_ids.compact.flatten)
    @orders = order_query.active_orders.page(1).per(20 * params[:page].to_i)
  end

  def create
    formatted_date = @date.strftime("%B %d")
    if @date.saturday?
      @message = "Nothing to process for tomorrow saturday"
    elsif SKIPPABLE_DATES.include?(formatted_date)
      @message = "Nothing to process for Blackout Date #{formatted_date}"
    else
      ScanovatorOrdersWorker.perform_async(@date)
      @message = "Process queued for #{formatted_date}"
    end
    respond_with(@message)
  end

  private

  def set_date
    @date = Date.parse(params[:date])
  end

  def locations
    array_of_locations = params[:location]&.split(",") || []
    array_of_locations << search_term_for_location
    array_of_locations.flatten
  end

  def meal_ids
    get_meal_ids << meal
  end

  def meal
    params[:meal]&.split(",")
  end

  def search_term_for_location
    params[:search_term_for_location]&.split(",") || []
  end

  def get_meal_ids
    Menu.search(params[:search_term_for_menus]).map(&:id)
  end
end
