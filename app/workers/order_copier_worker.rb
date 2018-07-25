class OrderCopierWorker
  include Sidekiq::Worker

  def perform(user_id)
    user = User.find(user_id)
    return unless user.orders.count % 20 == 0
    full_month_dates = MonthScheduler.new(user).create_full_month!
    orders = user.orders.where(status: [:completed, :processing]).last(20)
    20.times do |index|
      order = orders[index]
      range = DateRange.new(
                full_month_dates[index].beginning_of_day, 
                full_month_dates[index].end_of_day
              )

      new_order = user.orders.placed_between?(range).first_or_create!(
                placed_on: full_month_dates[index],
                order_date: Time.current,
                remarks: order.remarks
              )
      
      unless new_order.template?
        order.menus_orders.each do |menu_order|
          stock = Stock.new(menu_order.menu_id, menu_order.quantity)
          unless stock.empty?
            new_order.menus_orders.create!(
              menu_id: menu_order.menu_id,
              quantity: menu_order.quantity,
              add_ons: menu_order.add_ons
            )
          end
        end
      end
      
      new_order.processing!
      new_order.reduce_stock!
      RecordLedger.new(user, new_order).record!
      order.fulfilled!
    end
  end
end
