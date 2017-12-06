class InventoryTransactionDecorator < BaseDecorator
  def inventory_id
    inventory.inventory_id
  end

  def menu_name
    inventory.menu.name
  end
end