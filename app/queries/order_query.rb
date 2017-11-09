class OrderQuery
  attr_accessor :date, :orders

  def initialize(date = Date.current)
    @date = date
    @orders = Order.includes(:menus)
  end

  def active_orders
    results = orders.where(placed_on: date.beginning_of_day..date.end_of_day)

    class << self
      def size
        results.count
      end
    end

    results
  end

  def total_sales
    calculate_sales(orders)
  end

  def current_sales
    calculate_sales(active_orders)
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

  def calculate_sales(orders)
    sales = []
    orders.each do |o|
      sales.push(o.menus.map(&:price).reduce(:+))
    end
    sales.reduce(:+)
  end
end
