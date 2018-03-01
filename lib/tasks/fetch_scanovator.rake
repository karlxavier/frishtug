namespace :fetch_scanovator do
  task run: :environment do
    current_time = Time.current + 4.days
    range = DateRange.new(current_time.beginning_of_day, current_time.end_of_day)
    Order.placed_between?(range).each do |order|
      response = ScanovatorApi.fetch(order.id)
      next unless response.state == 'success'
      order.update(
        eta: response.data.first.eta,
        delivered_at: response.data.first.actually_delivered,
        payment_details: response.data.first.payment_details,
        route_started: response.data.first.route_started
      )
      order.completed! if response.data.first.actually_delivered != ''
    end
  end
end
