namespace :process_orders do
  task run: :environment do
    SKIPPABLE_STATUS = [
      "failed",
      "cancelled",
      "refunded",
      "fulfilled",
      "fresh", 
      "pending_payment", 
      "payment_failed"
    ].freeze

    current_date = Time.current
    range = DateRange.new(current_date.beginning_of_day, current_date.end_of_day)
    
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
end
