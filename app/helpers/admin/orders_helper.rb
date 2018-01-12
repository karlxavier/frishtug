module Admin::OrdersHelper
  def add_ons_list(menu_order)
    entries = []
    menu_order.add_ons.each do |a|
      add_on = AddOn.find(a)
      entries << "#{add_on.name} #{ "(#{to_currency(add_on.price)})" if add_on }"
    end
    entries.join(', ')
  end

  def total_price(price, quantity, add_ons)
    to_currency(
      calculate(price, quantity, add_ons_price(add_ons))
    )
  end

  def total_cost(order)
    totals = []
    order.menus_orders.each do |menu_order|
      quantity = menu_order.quantity
      totals << calculate(menu_order.menu_price,
        quantity, add_ons_price(menu_order.add_ons))
    end
    to_currency(totals.inject(:+))
  end

  def item_image(menu_order)
    cl_image_tag menu_order.menu.asset.image.thumb
  end

  private

  def add_ons_price(add_ons)
    add_ons.map { |a| AddOn.find(a)&.price }.inject(:+) || 0
  end

  def calculate(price, quantity, add_ons_price)
    (price * quantity) + (add_ons_price * quantity)
  end
end
