class OrderCalculator
  TAX = Tax.first.rate

  def initialize(order)
    @order = order
    @user = order&.user
    @minimum_charge = @user&.plan&.minimum_charge || 0
  end

  def total(options = {})
    shipping_charge = options[:skip_shipping_fee] == true ? 0 : shipping_fee
    total_price = total_item_price
    total_price = total_price > @minimum_charge ? total_price : @minimum_charge
    sum_of(
      total_price,
      total_add_ons_price,
      shipping_charge,
      self.class.new(order).total_tax)
  end

  def total_without_shipping
    sum_of(total_item_price, total_add_ons_price)
  end

  def total_without_tax
    sum_of(total_item_price, total_add_ons_price)
  end

  def total_excess(plan_limit)
    return 0 if plan_limit.blank?
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

  def total_tax
    taxable_items = order.menus_orders.select { |m| m.menu.tax == true }
    taxable_items.map {|o| calculate_tax(o.menu_price) * o.quantity }.inject(:+) || 0
  end

  def total_orders_tax
    return 0 unless @order.respond_to?(:each)
    orders = @order
    orders.map do |o|
      self.class.new(o).total_tax
    end.inject(:+) || 0
  end

  private

  attr_accessor :order, :user

  def shipping_fee
    fee = Plan.pluck(:id, :shipping_fee).to_h
    fee[order.user.plan_id] || 0
  end

  def sum_of(*nums)
    nums.inject(:+)
  end

  def convert_to_cents(num)
    (num.to_r * 100).to_i
  end

  def convert_to_dollars(cents)
    (cents / 100.0).round(2)
  end

  def calculate_tax(price)
    tax = (TAX / 100.0).to_d
    price = convert_to_cents(price)
    convert_to_dollars(price * tax)
  end

  def calculate(price, quantity)
    (sum_of(price.to_d, calculate_tax(price)) * quantity).to_d
  end

  def total_item_price
    order.menus_orders.map { |m| convert_to_dollars(convert_to_cents(m.menu_price) * m.quantity) }.inject(:+) || 0
  end

  def total_add_ons_price
    total = []
    add_on_price = AddOn.pluck_prices(:id)
    order.menus_orders.map do |m|
      add_ons_price = m.add_ons.map { |a| add_on_price[a.to_i] }.inject(:+) || 0
      total << convert_to_dollars(convert_to_cents(add_ons_price) * m.quantity)
    end
    total.inject(:+) || 0
  end
end
