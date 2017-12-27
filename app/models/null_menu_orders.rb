class NullMenuOrders
  attr_accessor :menu
  def initialize(menu)
    @menu = menu
  end

  def menu_id
    @menu.id
  end

  def quantity
    0
  end
end
