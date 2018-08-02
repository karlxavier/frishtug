class RecalculateOrdersWorker
  include Sidekiq::Worker
  CURRENT_TIME = Time.current + 1.day

  def perform(menu_id)
    order_ids = MenusOrder.where(menu_id: menu_id).pluck(:order_id)
    range = (CURRENT_TIME..Float::INFINITY)
    orders = Order.includes(:user).where(id: order_ids, placed_on: range)
    orders.find_each do |order|
      ChargeUser.call(order, order.user)
    end
  end
end