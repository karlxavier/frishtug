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
    return true if @order.template?
    ChargeUser.call(@order, @order.user)
    true
  end

  def notices
    @messages
  end

  private

  attr_accessor :date, :order_to_copy, :messages

  def copy_values_to(new_order)
    order_to_copy.menus_orders.each do |menu_order|
      item = new_order.menus_orders.where(menu_id: menu_order.menu_id).first_or_create
      item.update_attributes(
        quantity: menu_order.quantity,
        add_ons: menu_order.add_ons,
      )
    end
  end
end
