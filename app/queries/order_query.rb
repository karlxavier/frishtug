class OrderQuery
  def initialize(date_range, locations = nil, meal_ids = nil)
    @date_range = date_range
    @orders = Order
    @locations = locations
    @meal_ids = meal_ids
  end

  def active_orders
    @orders = Order.includes(user: :plan, menus_orders: :menu)
    results = filtered_orders.where(status: %i[processing payment_failed pending_payment])
                             .placed_between?(@date_range)
                             .order(series_number: :asc)

    class << self
      def size
        results.count
      end
    end

    results
  end

  def in_transit
    @orders = Order.includes(:user)
    results = filtered_orders.where.not(eta: [nil, ''])
                             .placed_between?(@date_range)

    class << self
      def size
        results.count
      end
    end

    results
  end

  def completed
    @orders = Order.includes(:user)
    results = filtered_orders.where(status: :completed)
                             .placed_between?(@date_range)
    class << self
      def size
        results.count
      end
    end

    results
  end

  def total_sales
    total(orders)
  end

  def current_sales
    total(active_orders)
  end

  def best_seller
    Plan.best_seller
  end

  def top_20_menu
    MenusOrder.top(20).to_a.in_groups_of(5, false)
  end

  def top_20_cities
    Address.top(20).to_a.in_groups_of(5, false)
  end

  private

  attr_accessor :date_range, :orders, :meal_ids, :locations

  def filtered_orders
    return orders_by_locations.merge(orders_by_meal_plan) if all_present?
    return orders_by_meal_plan if meal_ids.present?
    return orders_by_locations if locations.present?
    orders
  end

  def all_present?
    meal_ids.present? && locations.present?
  end

  def orders_by_meal_plan
    orders.where(id: MenusOrder.where(menu: menus).map(&:order_id).uniq)
  end

  def orders_by_locations
    orders.joins(:user).merge(User.in_locations(locations))
  end

  def menus
    Menu.where(id: meal_ids)
  end

  def total(orders)
    sales = []
    orders.each do |o|
      sales << OrderCalculator.new(o).total
    end
    sales.compact.reduce(:+)
  end
end
