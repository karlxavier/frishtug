class OrderQuery
  def initialize(date_range)
    @date_range = date_range
    @orders = Order.includes(:menus)
  end

  def active_orders
    results = orders.placed_between?(date_range)

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
  
  attr_accessor :date_range, :orders

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
