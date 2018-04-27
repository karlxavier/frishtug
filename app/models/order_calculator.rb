class OrderCalculator
  TAX = Tax.first.rate

  def initialize(order)
    @order = order
  end

  def total(options = {})
    fee = options[:skip_shipping_fee] == true ? 0 : shipping_fee
    sum_of(total_item_price, total_add_ons_price, fee)
  end

  def total_without_shipping
    sum_of(total_item_price, total_add_ons_price)
  end

  def total_without_tax
    sum_of(total_item_price_without_tax, total_add_ons_price)
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
      tax = self.class.new(order).total_tax
      if total > plan_limit
        excess << (total - tax) - plan_limit
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

  attr_accessor :order

  def shipping_fee
    fee = Plan.pluck(:id, :shipping_fee).to_h
    fee[order.user.plan_id] || 0
  end

  def sum_of(*nums)
    nums.inject(:+)
  end

  def total_item_price_without_tax
   order.menus_orders.map { |m| m.menu_price * m.quantity }.inject(:+) || 0
  end

  def convert_to_cents(price)
    (price.to_r * 100).to_i
  end

  def calculate_tax(price)
    tax = TAX / 100
    (price * tax).to_d
  end

  def calculate(price, quantity)
    sum_of(price.to_r, calculate_tax(price)) * quantity
  end

  def total_item_price
    taxable_items = order.menus_orders.select { |m| m.menu.tax == true }
    not_taxable_items = order.menus_orders.reject { |m| m.menu.tax == true }

    taxable_items_total = taxable_items
        .map { |t| calculate(t.menu_price, t.quantity) }.inject(:+) || 0
    not_taxable_items_total = not_taxable_items
        .map { |m| m.menu_price * m.quantity }.inject(:+) || 0

    sum_of(taxable_items_total, not_taxable_items_total)
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
