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
    @order.processing!
    @order.reduce_stocks!
    RecordLedger.new(@order.user, @order).record!
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
        item = new_order.menus_orders.where(menu_id: menu_order.menu_id).first_or_create
        item.update_attributes(
          quantity: menu_order.quantity,
          add_ons: menu_order.add_ons
        )
      else
        messages << "Not enough stock for #{menu_order.menu.name} in #{new_order.placed_on.strftime('%B %d, %Y')}"
      end
    end
  end
end