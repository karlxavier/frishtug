# frozen_string_literal: true

class ShoppingCart
  include ActiveModel::Validations

  def initialize(order)
    @order = order
  end

  def place_order(menu, quantity, add_on_id)
    if add_on_id.nil?
      menus_order = create_menus_order(menu.id)
      check_stocks_and_add_quantity(menus_order, menu.id, quantity)
    else
      menus_order = get_menus_order(menu.id)
      return unless menus_order.present?
      add_add_ons(menus_order, quantity, add_on_id) if menus_order.present?
      menus_order.save
    end
  end

  def remove_order(menu, quantity, add_on_id)
    menus_order = get_menus_order(menu.id)
    return unless menus_order.present?
    remove_add_on(menus_order, quantity, add_on_id)
    subtract_quantity_or_delete(menus_order, menu.id, quantity)
  end

  private

  attr_accessor :order

  def check_stocks_and_add_quantity(menus_order, menu_id, quantity)
    menus_order.quantity += quantity.to_f
    menus_order.save
    true
  end

  def create_menus_order(menu_id)
    order.menus_orders.where(menu_id: menu_id).first_or_create(quantity: 0)
  end

  def add_add_ons(menus_order, _quantity, add_on_id)
    return unless add_on_id.present?
    return if menus_order.add_ons.include?(add_on_id)
    add_on = AddOn.find(add_on_id)
    menus_order.add_ons << add_on.id
  end

  def get_menus_order(menu_id)
    order.menus_orders.where(menu_id: menu_id).first
  end

  def remove_add_on(menus_order, _quantity, add_on_id)
    return unless add_on_id.present?
    add_on = AddOn.find(add_on_id)
    add_on_index = menus_order.add_ons.index(add_on_id)
    return if add_on_index.nil?
    menus_order.add_ons.delete_at(add_on_index)
  end

  def subtract_quantity_or_delete(menus_order, menu_id, quantity)
    menus_order.quantity -= quantity.to_i
    menus_order.save
    menus_order.destroy if menus_order.quantity == 0
    true
  end
end
