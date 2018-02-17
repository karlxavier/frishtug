class ShoppingCart
  include ActiveModel::Validations

  def initialize(order)
    @order = order
  end

  def place_order(menu, quantity, add_on_id)
    menus_order = create_menus_order(menu.id)
    add_add_ons(menus_order, quantity, add_on_id)
    check_stocks_and_add_quantity(menus_order, menu.id, quantity)
  end

  def remove_order(menu, quantity, add_on_id)
    menus_order = get_menus_order(menu.id)
    remove_add_on(menus_order, quantity, add_on_id)
    subtract_quantity_or_delete(menus_order, menu.id, quantity)
  end

  private

    attr_accessor :order

    def check_stocks_and_add_quantity(menus_order, menu_id, quantity)
      stock = Stock.new(menu_id, quantity)
      if stock.empty?
        errors.add(:base, 'Out of stocks!')
        false
      else
        menus_order.quantity += quantity.to_f
        menus_order.save

        return true if order.fresh?
        stock.reduce
        StockAccounter.new(stock, order.placed_on).increase
        true
      end
    end

    def create_menus_order(menu_id)
      order.menus_orders.where(menu_id: menu_id).first_or_create(quantity: 0)
    end

    def add_add_ons(menus_order, quantity, add_on_id)
      return unless add_on_id.present?
      return if menus_order.add_ons.include?(add_on_id)
      add_on = AddOn.find(add_on_id)
      menus_order.add_ons << add_on.id

      return if order.fresh?
      stock = Stock.new(add_on.menu_id, quantity)
      stock.reduce
      StockAccounter.new(stock, order.placed_on).increase
    end

    def get_menus_order(menu_id)
      order.menus_orders.where(menu_id: menu_id).first
    end

    def remove_add_on(menus_order, quantity, add_on_id)
      return unless add_on_id.present?
      add_on = AddOn.find(add_on_id)
      menus_order.add_ons.delete_at(menus_order.add_ons.index(add_on_id))

      return if order.fresh?
      stock = Stock.new(add_on.menu_id, quantity)
      stock.return
      StockAccounter.new(stock, order.placed_on).decrease
    end

    def subtract_quantity_or_delete(menus_order, menu_id, quantity)
      menus_order.quantity -= quantity.to_i
      menus_order.save
      if menus_order.quantity == 0
        menus_order.destroy
      end


      return true if order.fresh?
      stock = Stock.new(menu_id, quantity)
      stock.return
      StockAccounter.new(stock, order.placed_on).decrease
      true
    end
end