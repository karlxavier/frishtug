class CreateBlackoutRefundWorker
  include Sidekiq::Worker

  def perform(order_id)
    order = Order.find_by_id(order_id)
    if order
      CreateRefundForBlackoutDate.new(order).process
    end
  end
end
