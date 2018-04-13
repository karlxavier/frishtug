class ScanovatorOrdersWorker
  include Sidekiq::Worker

  def perform(placed_date)
    @placed_date = placed_date
    orders = Order.placed_between?(range)
    orders.each do |order|
      next if order.fresh?
      scanovator_api = ScanovatorApi.new_order(order)
      if scanovator_api.errors
        Rails.logger.info scanovator_api.errors.full_messages.join(', ')
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
