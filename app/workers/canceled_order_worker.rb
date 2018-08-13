class CanceledOrderWorker
  include Sidekiq::Worker

  def perform(order_id)
    @order = Order.find_by_id(order_id)
    return unless @order
    CreateRefundForCanceledOrder.new(@order).process
  end
end
