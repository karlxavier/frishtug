class StockWorker
  include Sidekiq::Worker

  def perform(order_id)
    order = Order.find_by_id(order_id)
    if order
      InventoryAccounter.new(order).run
    end
  end
end
