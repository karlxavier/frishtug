namespace :fix_series do
  task run: :environment do
    placed_ons = Order.pluck(:placed_on).uniq
    placed_ons.each do |date|
      range = DateRange.new(date.beginning_of_day, date.end_of_day)
      orders = Order.placed_between?(range)
      start_num = 0
      orders.order(id: :asc).each do |order|
        start_num += 1
        order.series_number = start_num
        order.save
      end
    end
  end
end
