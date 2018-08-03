class CanceledOrderWorker
  include Sidekiq::Worker

  def perform(order_id)
    @order = Order.find(order_id)
    CreateRefundForCanceledOrder.new(@order).process
  end
end