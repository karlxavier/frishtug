class OrderCopier
  include ActiveModel::Validations

  attr_accessor :ids
  WDAY_TO_SKIP = {
    sunday: 0,
    friday: 5,
  }
  def initialize(last_five_orders, user)
    @user = user
    @last_five_orders = last_five_orders
    @messages = []
  end

  def notices
    @messages
  end

  def copy_to(dates = [])
    ActiveRecord::Base.transaction do
      clean_duplicates(dates)
      @last_five_orders.each_with_index do |order, index|
        next unless dates[index].present?
        user_order = @user.orders.create!(order_params(dates[index], order))
        create_menus_orders(user_order, order)
        user_order.processing!
        RecordLedger.new(user, user_order).record!
      end
    end
    true
  rescue ActiveRecord::StatementInvalid => e
    errors.add(:base, e.message)
    false
  rescue ActiveRecord::RecordInvalid => e
    errors.add(:base, e.message)
    false
  end

  def run
    return false unless @user.order_preference&.copy_menu
    placed_on_date = @last_five_orders.last.placed_on + 1.days
    orders = @last_five_orders * 3
    ActiveRecord::Base.transaction do
      orders.each_with_index do |order, index|
        placed_on_date = new_placed_on_date(placed_on_date)
        user_order = @user.orders.create!(order_params(placed_on_date, order))
        create_menus_orders(user_order, order)
        placed_on_date += 1.day
      end
    end
    true
  rescue ActiveRecord::StatementInvalid => e
    errors.add(:base, e.message)
    false
  rescue ActiveRecord::RecordInvalid => e
    errors.add(:base, e.message)
    false
  end

  private

  attr_accessor :user, :excess, :messages, :taxes

  def clean_duplicates(dates = [])
    start_date  = parse_date(dates.first).beginning_of_day
    end_date    = parse_date(dates.last).end_of_day
    range       = DateRange.new(start_date, end_date)
    orders      = user.orders.placed_between?(range)
    if orders.count > 0
      orders.destroy_all
    end
  end

  def parse_date(date)
    Time.zone.parse(date)
  end

  def set_day(day)
    return day = 0 if day == 4
    day += 1
  end

  def order_params(placed_on_date, current_order)
    {
      placed_on: placed_on_date,
      order_date: Time.current,
      remarks: current_order.remarks,
      status: :fresh
    }
  end

  def new_placed_on_date(placed_on_date)
    if placed_on_date.saturday?
      placed_on_date += 1.days
    end

    if placed_on_date.wday == day_to_skip
      placed_on_date += 1.days
      placed_on_date += 1.days if placed_on_date.saturday?
    end

    placed_on_date
  end

  def create_menus_orders(user_order, current_order)
    current_order.menus_orders.each do |menu_order|
      stock = Stock.new(menu_order.menu_id, menu_order.quantity)
      unless stock.empty?
        user_order.menus_orders.create!(
          menu_id: menu_order.menu_id,
          quantity: menu_order.quantity,
          add_ons: menu_order.add_ons
        )
      else
        messages << "Not enough stock for #{menu_order.menu.name} in #{user_order.placed_on.strftime('%B %d, %Y')}"
      end
    end
  end

  def day_to_skip
    return nil unless user.schedule.present?
    if user.schedule.monday_to_friday?
      return WDAY_TO_SKIP[:sunday]
    end

    if user.schedule.sunday_to_thursday?
      return WDAY_TO_SKIP[:friday]
    end
  end
end