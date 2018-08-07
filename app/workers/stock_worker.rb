class StockWorker
  include Sidekiq::Worker

  def perform(order_id)
    order
    # Do something
  end
end
