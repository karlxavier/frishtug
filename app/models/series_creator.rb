class SeriesCreator
  def initialize(date)
    @range = DateRange.new(date.beginning_of_day, date.end_of_day)
    @orders = Order.placed_between?(@range).order(id: :asc)
  end

  def create
    series = 1
    @orders.map do |order|
      if order&.series_number == series
        series +=1
      end
    end
    series
  end
end
