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
      sales.push(o.menus.map(&:price).reduce(:+))
    end
    sales.compact.reduce(:+)
  end
end
