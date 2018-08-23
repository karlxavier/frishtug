class CancelOrdersWorker
  include Sidekiq::Worker

  def perform
    current_time = Time.current
    range = DateRange.new(current_time.beginning_of_day, current_time.end_of_day)
    orders = Order.placed_between?(range).processing
    orders.each do |order|
      order.cancelled!
      CreateRefundForCanceledOrder.new(order, order.user).process
    end
    ActionCable.server.broadcast "orders_channel",
      message: "#{orders.size} #{"order".pluralize(orders.size)} canceled",
      title: "Canceled todays order"
  end
end
