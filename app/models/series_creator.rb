class SeriesCreator
  def initialize(order)
    @current_order = order
    date = order.placed_on
    @range = DateRange.new(date.beginning_of_day, date.end_of_day)

  end

  def create
    last_series_number =
      Order.placed_between?(@range).order('series_number DESC')                 .first.series_number || 0
    raise Order.placed_between?(@range).inspect
    last_series_number + 1
  end
end
