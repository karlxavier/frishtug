class FetchOrdersStatus

  def initialize(date = nil)
    @current_time = if date.nil?
      Time.current
    else
      Time.zone.parse(date)
    end
  end

  def run
    return if @current_time.saturday?
    return unless (5..22).cover? Time.current.hour
    range = DateRange.new(@current_time.beginning_of_day, @current_time.end_of_day)
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