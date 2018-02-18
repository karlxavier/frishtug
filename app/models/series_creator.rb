class SeriesCreator
  def initialize(date)
    @range = DateRange.new(date.beginning_of_day, date.end_of_day)
    @last_order = Order.placed_between?(@range).order(id: :asc).last
  end

  def create
    series = @last_order.try(:series_number) || 0
    series += 1
  end
end
