class OrderCopierWorker
  include Sidekiq::Worker

  def perform(user_id, old_start_date, old_end_date)
    start_date = Time.zone.parse(old_start_date)
    end_date = Time.zone.parse(old_end_date)
    old_range = DateRange.new(start_date.beginning_of_day, end_date.end_of_day)
    user = User.find_by_id(user_id)
    if user
      full_month_dates = MonthScheduler.new(user).create_full_month!
      orders = user.orders.placed_between?(old_range).
        where(status: [:processing, :completed, :cancelled]).
        order(placed_on: :asc)

      return if orders.length == 0
      return unless orders.length % 20 == 0

      20.times do |index|
        order = orders[index]
        range = DateRange.new(
          full_month_dates[index].beginning_of_day,
          full_month_dates[index].end_of_day
        )

        new_order = user.orders.placed_between?(range).first_or_create!(
          placed_on: full_month_dates[index],
          order_date: Time.current,
          remarks: order.remarks,
        )

        unless new_order.template?
          order.menus_orders.each do |menu_order|
            stock = Stock.new(menu_order.menu_id, menu_order.quantity)
            unless stock.empty?
              new_order.menus_orders.create!(
                menu_id: menu_order.menu_id,
                quantity: menu_order.quantity,
                add_ons: menu_order.add_ons,
              )
            end
          end
        end

        new_order.processing!
        new_order.reduce_stocks!
        RecordLedger.new(user, new_order).record!
        order.fulfilled!
      end
    end
  end
end
