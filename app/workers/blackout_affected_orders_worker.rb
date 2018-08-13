class BlackoutAffectedOrdersWorker
  include Sidekiq::Worker

  def perform(blackout_date_id)
    blackout_date = BlackoutDate.find_by_id(blackout_date_id)
    if blackout_date
      date = Time.zone.parse("#{blackout_date.month} #{blackout_date.day}")
      range = DateRange.new(date.beginning_of_day, date.end_of_day)
      orders_affected = Order.placed_between?(range)
      orders_affected.map { |order| order.save }
    end
  end
end
