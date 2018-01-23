class OrderDuplicator
  include ActiveModel::Validations

  validates :order, :date, presence: true
  def initialize(order, date)
    @order = order
    @date = date
    valid?
  end

  def run
    copy_values_to(create_order_from_date)
    true
  end

  private

  attr_accessor :date, :order

  def create_order_from_date
    Order.create!(order_params)
  end

  def order_params
    {
      user_id: order.user_id,
      placed_on: date,
      order_date: Time.current,
      remarks: order.remarks
    }
  end

  def copy_values_to(new_order)
    order.menus_orders.each do |menu_order|
      new_order.menus_orders.create!(
        menu_id: menu_order.menu_id,
        quantity: menu_order.quantity,
        add_ons: menu_order.add_ons
      )
    end
  end
end