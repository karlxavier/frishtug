class ShippingChargeWorker
  include Sidekiq::Worker

  def perform(shipping_price_id)
    shipping = ShippingPrice.find_by_id(shipping_price_id)
    if shipping
      party_meeting_plan = Plan.where(for_type: "party_meeting").first
      user_ids = User.joins(:addresses).where(plan_id: party_meeting_plan.id, addresses: {zip_code: shipping.zip.to_s, status: :active}).ids
      orders = Order.includes(:user).where(user_id: user_ids, status: :pending_payment)

      orders.find_each do |order|
        RecordLedger.new(order.user, order).record_shipping!
      end
    end
  end
end
