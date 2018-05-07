class OrderDuplicator
  include ActiveModel::Validations

  def initialize(order_to_copy, date, order)
    @order_to_copy = order_to_copy
    @date = date
    @order = order
  end

  def run
    copy_values_to(@order)
    @order.processing!
    ChargeUser.call(@order, @user)
    true
  end

  private

  attr_accessor :date, :order_to_copy

  def copy_values_to(new_order)
    order_to_copy.menus_orders.each do |menu_order|
      new_order.menus_orders.create!(
        menu_id: menu_order.menu_id,
        quantity: menu_order.quantity,
        add_ons: menu_order.add_ons
      )
    end
  end
end