class AddQuantityToMenusOrders < ActiveRecord::Migration[5.1]
  def change
    add_column :menus_orders, :quantity, :integer
  end
end
