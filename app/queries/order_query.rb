class OrderQuery
  def initialize(date_range, location = nil, meal_plan_ids = nil)
    @date_range = date_range
    @orders = Order.includes(:menus)
    @location = location
    @meal_plan_ids = meal_plan_ids
  end

  def active_orders
    results = filtered_orders.placed_between?(@date_range)

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
    best = { name: nil, size: 0 }
    Plan.all.each do |p|
      if p.users.size > best[:size]
        best[:name] = p.name
        best[:size] = p.users.size
      end
    end
    best
  end

  private

  attr_accessor :date_range, :orders, :meal_plan_ids, :location

  def filtered_orders
    return orders_by_meal_plan if meal_plan_ids.present?
    return orders_by_location if location.present?
    orders
  end

  def orders_by_meal_plan
    orders.joins(:menus_orders).merge(MenusOrder.where(menu_id: menu_ids))
  end

  def orders_by_location
    orders.joins(:user).merge(User.in_city(location))
  end

  def menu_ids
    Menu.where(id: meal_plan_ids).map(&:id)
  end

  def total(orders)
    sales = []
    orders.each do |o|
      o.menus_orders.each do |menu_order|
        price = menu_order.menu_price
        quantity = menu_order.quantity
        add_ons_price = total_add_ons_price(menu_order.add_ons)
        sales.push(calculate(price, quantity, add_ons_price))
      end
    end
    sales.compact.reduce(:+)
  end

  def calculate(price, quantity, add_ons_price)
    (price * quantity) + (add_ons_price * quantity)
  end

  def total_add_ons_price(add_ons)
    add_ons.map { |a| AddOn.find(a)&.price }.inject(:+) || 0
  end
end
