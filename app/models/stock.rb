# frozen_string_literal: true

class Stock
  attr_accessor :inventory, :quantity
  def initialize(menu_id, quantity)
    @inventory = Inventory.find_by_menu_id(menu_id)
    @quantity = quantity.to_f
  end

  def reduce
    return if inventory.nil?
    inventory.decrement! :quantity, quantity
    inventory.save
  end

  def return
    return if inventory.nil?
    inventory.increment! :quantity, quantity
    inventory.save
  end

  def remaining_stocks
    inventory.quantity - quantity
  end

  def empty?
    inventory.quantity.zero?
  end

  def enough?
    inventory.quantity >= quantity
  end

  def available_quantity
    return quantity if remaining_stocks >= 0
    quantity = inventory.quantity
    quantity
  end

  class << self
    def is_empty?(menu_ids:)
      Inventory.where(menu_id: menu_ids, quantity: 0).any?
    end

    def is_enough?(menu_id:, quantity:)
      Inventory.where(menu_id: menu_id, quantity: quantity..Float::INFINITY).any?
    end

    def not_enough?(menus_orders:)
      menus_orders.map { |mo| Stock.is_enough?(menu_id: mo.menu_id, quantity: mo.quantity) }.any? { |i| i == false }
    end
  end
end
