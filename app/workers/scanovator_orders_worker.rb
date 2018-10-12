class ScanovatorOrdersWorker
  include Sidekiq::Worker
  SKIPPABLE_STATUS = [
    "failed",
    "cancelled",
    "refunded",
    "fulfilled",
    "fresh",
    "pending_payment",
    "payment_failed",
  ].freeze

  def perform(placed_date)
    @placed_date = placed_date
    orders = Order.includes(:user).where(status: [:processing, :awaiting_shipment]).placed_between?(range)
    orders.each do |order|
      next if SKIPPABLE_STATUS.include?(order.status)
      next if order.is_rollover
      next if order.user.active_address.nil?

      scanovator_api = ScanovatorApi.new_order(order)
      next unless scanovator_api.present?
      if scanovator_api.error
        Rails.logger.info scanovator_api.error
      else
        order.update_attributes(is_rollover: true)
        order.processing!
        order.reduce_stocks!
        ChargeGroup.call(order.user, order)
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
