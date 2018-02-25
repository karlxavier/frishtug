class ShoppingListQuery
  def initialize(date)
    @date = date
  end

  def get_list
    list = []
    Menu.all_published.map do |menu|
      orders = menu.orders.placed_between?(range)
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
      quantity: MenusOrder.where(order_id: orders.pluck(:id)).map(&:quantity).inject(:+)
    }
  end

  def range
    DateRange.new(date.beginning_of_day, date.end_of_day)
  end
end