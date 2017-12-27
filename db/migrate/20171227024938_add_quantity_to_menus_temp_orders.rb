class AddQuantityToMenusTempOrders < ActiveRecord::Migration[5.1]
  def change
    add_column :menus_temp_orders, :quantity, :integer, default: 0
  end
end
