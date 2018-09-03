class OrderCopierWorker
  include Sidekiq::Worker

  def perform(user_id, old_start_date, old_end_date)
    new_order_ids = []
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
        new_order_ids << new_order.id
        order.fulfilled!
      end

      return if new_order_ids.empty?
      
      unpaid_ledgers = Ledger.where(order_id: new_order_ids, status: :pending_payment)

      return if unpaid_ledgers.empty?

      amount_to_cents = (unpaid_ledgers.total * 100).to_i

      return if amount_to_cents.zero?

      charge = Stripe::Charge.create(
        amount: amount_to_cents,
        currency: "usd",
        customer: user.stripe_customer_id,
        description: "Payment for bills",
      )

      unpaid_ledgers.find_each { |b| b.update_attributes(status: :paid, charge_id: charge.id) }
    end
  end
end
