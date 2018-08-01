class CreateBlackoutRefundWorker
  include Sidekiq::Worker

  def perform(order_id)
    @order = Order.find(order_id)
    CreateRefundForBlackoutDate.new(@order).process
  end
end