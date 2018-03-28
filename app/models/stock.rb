class Stock
  attr_accessor :inventory, :quantity
  def initialize(menu_id, quantity)
    @inventory = Inventory.find_by_menu_id(menu_id)
    @quantity = quantity.to_f
  end

  def reduce
    return if inventory.nil?
    inventory.quantity -= quantity
    inventory.save
  end

  def return
    return if inventory.nil?
    inventory.quantity += quantity
    inventory.save
  end

  def empty?
    remaining_stocks = inventory.quantity - quantity
    remaining_stocks <= 0
  end
end