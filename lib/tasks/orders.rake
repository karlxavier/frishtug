namespace :orders do
  desc "TODO"
  task populate_series_number: :environment do
    dates = Order.pluck(:placed_on).uniq
    dates.each do |date|
      range = DateRange.new(date.beginning_of_day, date.end_of_day)
      orders = Order.placed_between?(range).order(:id)
      orders.each_with_index do |order, index|
        order.update_attributes(series_number: index + 1)
      end
    end
  end
end
