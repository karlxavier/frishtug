class OrderCalculator

  def initialize(order)
    @order = order
    @user = if @order.respond_to?(:each)
      @order.first.user
    else
      @order.user
    end
    @minimum_charge = @user.plan&.minimum_charge || 0
    @limit = @user.plan&.limit || 0
  end

  def total(options = {})
    shipping_charge = options[:skip_shipping_fee] == true ? 0 : shipping_fee
    total_price = total_item_price + total_add_ons_price
    total_price = total_price > @minimum_charge ? total_price : @minimum_charge
    sum_of(
      total_price,
      shipping_charge,
      self.class.new(order).total_tax)
  end

  def total_without_shipping
    sum_of(total_item_price, )
  end

  def total_without_tax
    sum_of(total_item_price, total_add_ons_price)
  end

  def total_excess
    return 0 unless @limit.present? && @limit > 0
    total = sum_of(total_item_price, total_add_ons_price)
    return 0 if total < @limit
    excess = total - @limit
  end

  def get_excess
    orders = @order
    excess = []
    orders.each do |order|
      total = self.class.new(order).total_without_shipping
      if total > @limit
        excess << total - @limit
      end
    end
    excess.inject(:+) || 0
  end

  def total_tax
    taxable_items = order.menus_orders.select { |m| m.menu.tax == true }
    total = taxable_items.map {|o| calculate_tax(o.menu_price) * o.quantity }.inject(:+) || 0
    total + total_add_ons_tax
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
    MoneyConverter.new(num).to_cents
  end

  def convert_to_dollars(cents)
    MoneyConverter.new(cents).to_dollars
  end

  def calculate_tax(price)
    TaxCalculator.new(price).calculate
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

  def total_add_ons_tax
    total = []
    order.menus_orders.map do |m|
      menu_ids = AddOn.where(id: m.add_ons).pluck(:menu_id).compact
      menus = Menu.where(id: menu_ids, tax: true)
      next if menus.size <= 0
      menus.each do |menu|
        total << convert_to_dollars(convert_to_cents(calculate_tax(menu.price)) * m.quantity)
      end
    end
    total.inject(:+) || 0
  end
end
