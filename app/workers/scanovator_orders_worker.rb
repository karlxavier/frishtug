class ScanovatorOrdersWorker
  include Sidekiq::Worker
  SKIPPABLE_STATUS = [
    "failed",
    "cancelled",
    "refunded",
    "fulfilled",
    "fresh", 
    "pending_payment", 
    "payment_failed"
  ].freeze

  def perform(placed_date)
    @placed_date = placed_date
    orders = Order.placed_between?(range)
    orders.each do |order|
      next if SKIPPABLE_STATUS.include?(order.status)
      scanovator_api = ScanovatorApi.new_order(order)
      next unless scanovator_api.present?
      if scanovator_api.error
        Rails.logger.info scanovator_api.error
      end
    end
  end

  private

  def range
    DateRange.new(date.beginning_of_day, date.end_of_day)
  end

  def date
    Date.parse(@placed_date)
  end
end
