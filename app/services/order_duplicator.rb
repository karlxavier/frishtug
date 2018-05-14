class OrderDuplicator
  include ActiveModel::Validations

  def initialize(order_to_copy, date, order)
    @order_to_copy = order_to_copy
    @date = date
    @order = order
    @messages = []
  end

  def run
    copy_values_to(@order)
    @order.processing!
    ChargeUser.call(@order, @user)
    true
  end

  def notices
    @messages
  end

  private

  attr_accessor :date, :order_to_copy, :messages

  def copy_values_to(new_order)
    order_to_copy.menus_orders.each do |menu_order|
      stock = Stock.new(menu_order.menu_id, menu_order.quantity)
      unless stock.empty?
        new_order.menus_orders.create!(
          menu_id: menu_order.menu_id,
          quantity: menu_order.quantity,
          add_ons: menu_order.add_ons
        )
      else
        messages << "Not enough stock for #{menu_order.menu.name} in #{user_order.placed_on.strftime('%B %d, %Y')}"
      end
    end
  end
end