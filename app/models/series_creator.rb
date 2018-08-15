# frozen_string_literal: true

class SeriesCreator
  def initialize(order)
    @current_order = order
    @date = order.placed_on
    @range = DateRange.new(@date.beginning_of_day, @date.end_of_day)
  end

  def create
    last_series_number =
      Order.unscoped.placed_between?(@range).pluck(:series_number).uniq.compact.max
    if last_series_number.nil?
      return 1
    else
      return last_series_number + 1
    end
  end
end
