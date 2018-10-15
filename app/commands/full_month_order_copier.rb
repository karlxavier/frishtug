class FullMonthOrderCopier
  prepend SimpleCommand

  def initialize(user)
    @user = user
    @full_month_dates = MonthScheduler.new(@user).create_full_month!
    @orders_to_copy = @user.orders.where.not(status: :template).order(placed_on: :asc).last(20)
  end

  def call
    process_copy!
  end

  private

  attr_reader :user, :full_month_dates, :orders_to_copy

  def process_copy!
    new_order_ids = []
    orders = orders_to_copy
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
          new_order.menus_orders.create!(
            menu_id: menu_order.menu_id,
            quantity: menu_order.quantity,
            add_ons: menu_order.add_ons,
          )
        end
      end

      new_order.awaiting_shipment!
      RecordLedger.new(user, new_order).record!
      new_order_ids << new_order.id
      # order.fulfilled!
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