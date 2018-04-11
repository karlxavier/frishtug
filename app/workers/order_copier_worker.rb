class OrderCopierWorker
  include Sidekiq::Worker

  def perform(user_id)
    user = User.find(user_id)
    return unless user.orders.all?(&:completed?) && user.orders.count % 20 == 0
    full_month_dates = MonthScheduler.new(user).create_full_month!
    orders = user.orders.first(20)
    20.times do |index|
      order = orders[index]
      new_order = user.orders.create!(
        placed_on: full_month_dates[index],
        order_date: Time.current,
        remarks: order.remarks,
        status: :processing
      )

      order.menus_orders.each do |menu_order|
        new_order.menus_orders.create!(
          menu_id: menu_order.menu_id,
          quantity: menu_order.quantity,
          add_ons: menu_order.add_ons
        )
      end
      order.fulfilled!
    end
  end
end
