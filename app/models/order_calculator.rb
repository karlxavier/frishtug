class OrderCalculator
  def initialize(order)
    @order = order
  end

  def total
    sum_of(total_item_price, total_add_ons_price)
  end

  def get_excess(plan_limit)
    orders = @order
    excess = []
    orders.each do |order|
      total = sum_of(total_item_price_for(order), total_add_ons_price_for(order))
      if total > plan_limit
        excess << total - plan_limit
      end
    end
    excess.inject(:+) || 0
  end

  private

  attr_accessor :order

  def sum_of(*nums)
    nums.inject(:+)
  end

  def total_item_price_for(order)
    order.menus_orders.map { |m| m.menu_price * m.quantity }.inject(:+)
  end

  def total_item_price
    order.menus_orders.map { |m| m.menu_price * m.quantity }.inject(:+)
  end

  def total_add_ons_price
    total = []
    add_on_price = AddOn.pluck(:id, :price).to_h
    order.menus_orders.map do |m|
      add_ons_price = m.add_ons.map { |a| add_on_price[a.to_i] }.inject(:+) || 0
      total << add_ons_price * m.quantity
    end
    total.inject(:+)
  end

  def total_add_ons_price_for(order)
    total = []
    add_on_price = AddOn.pluck(:id, :price).to_h
    order.menus_orders.map do |m|
      add_ons_price = m.add_ons.map { |a| add_on_price[a.to_i] }.inject(:+) || 0
      total << add_ons_price * m.quantity
    end
    total.inject(:+)
  end
end