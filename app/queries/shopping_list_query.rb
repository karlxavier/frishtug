class ShoppingListQuery
  def initialize(date)
    @date = date
  end

  def get_list
    list = []
    Menu.all_published.map do |menu|
      orders = menu.orders.awaiting_shipment.placed_between?(range)
      list << format_result(orders, menu) if orders.present?
    end
    list
  end

  private

  attr_accessor :date

  def format_result(orders, menu)
    {
      menu: menu,
      order_ids: orders.pluck(:series_number),
      quantity: get_quantity(orders.ids, menu.id),
    }
  end

  def range
    DateRange.new(date.beginning_of_day, date.end_of_day)
  end

  def get_quantity(order_ids, menu_id)
    MenusOrder.where(order_id: order_ids, menu_id: menu_id).map(&:quantity).inject(:+)
  end
end
