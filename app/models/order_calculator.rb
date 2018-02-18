class OrderCalculator
  def initialize(order)
    @order = order
  end

  def total
    sum_of(total_item_price, total_add_ons_price, shipping_fee)
  end

  def total_without_shipping
    sum_of(total_item_price, total_add_ons_price)
  end

  def total_excess(plan_limit)
    total = sum_of(total_item_price, total_add_ons_price)
    total - plan_limit
  end

  def get_excess(plan_limit)
    orders = @order
    excess = []
    orders.each do |order|
      total = self.class.new(order).total_without_shipping
      if total > plan_limit
        excess << total - plan_limit
      end
    end
    excess.inject(:+) || 0
  end

  private

  attr_accessor :order

  def shipping_fee
    fee = Plan.pluck(:id, :shipping_fee).to_h
    fee[order.user.plan_id] || 0
  end

  def sum_of(*nums)
    nums.inject(:+)
  end

  def total_item_price
    order.menus_orders.map { |m| m.menu_price * m.quantity }.inject(:+) || 0
  end

  def total_add_ons_price
    total = []
    add_on_price = AddOn.pluck_prices(:id)
    order.menus_orders.map do |m|
      add_ons_price = m.add_ons.map { |a| add_on_price[a.to_i] }.inject(:+) || 0
      total << add_ons_price * m.quantity
    end
    total.inject(:+) || 0
  end
end