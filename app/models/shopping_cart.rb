class ShoppingCart
  include ActiveModel::Validations

  def initialize(order)
    @order = order
  end

  def place_order(menu, quantity, add_on_id)
    menus_order = create_menus_order(menu.id)
    add_add_ons(menus_order, add_on_id)
    check_stocks_and_add_quantity(menus_order, menu.id, quantity)
  end

  def remove_order(menu, quantity, add_on_id)
    menus_order = get_menus_order(menu.id)
    remove_add_on(menus_order, add_on_id)
    subtract_quantity_or_delete(menus_order, quantity)
  end

  private

    attr_accessor :order

    def check_stocks_and_add_quantity(menus_order, menu_id, quantity)
      if check_stocks!(menu_id, quantity)
        errors.add(:base, 'Out of stocks!')
        false
      else
        menus_order.quantity += quantity.to_i
        menus_order.save
      end
    end

    def create_menus_order(menu_id)
      order.menus_orders.where(menu_id: menu_id).first_or_create!
    end

    def check_stocks!(menu_id, quantity)
      inventory = Inventory.find_by_menu_id(menu_id)
      current_stocks = inventory.quantity - quantity.to_i
      current_stocks <= 0
    end

    def add_add_ons(menus_order, add_on_id)
      return unless add_on_id.present?
      return if menus_order.add_ons.include?(add_on_id)
      menus_order.add_ons << AddOn.find(add_on_id).id
    end

    def get_menus_order(menu_id)
      order.menus_orders.where(menu_id: menu_id).first
    end

    def remove_add_on(menus_order, add_on_id)
      return unless add_on_id.present?
      menus_order.add_ons.delete_at(menus_order.add_ons.index(add_on_id))
    end

    def subtract_quantity_or_delete(menus_order, quantity)
      menus_order.quantity -= quantity.to_i
      menus_order.save if menus_order.quantity > 0
      menus_order.destroy
    end
end