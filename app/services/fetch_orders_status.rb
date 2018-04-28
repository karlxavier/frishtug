class FetchOrdersStatus
  def run
    current_time = Time.current
    return if current_time.saturday?
    range = DateRange.new(current_time.beginning_of_day, current_time.end_of_day)
    order_ids = Order.placed_between?(range).map(&:id)
    response = ScanovatorApi.fetch_group(order_ids)
    return true if response.state == 'fail'
    response.data.each do |data|
      order = Order.find(data.order_id)
      order.update(
        eta: data.eta,
        delivered_at: data.actually_delivered,
        payment_details: data.payment_details,
        route_started: data.route_started
      )
      order.completed! if data.eta.nil?
    end
    true
  end
end