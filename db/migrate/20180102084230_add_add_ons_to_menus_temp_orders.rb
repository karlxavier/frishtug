class AddAddOnsToMenusTempOrders < ActiveRecord::Migration[5.1]
  def change
    add_column :menus_temp_orders, :add_ons, :string, array: true, default: []
  end
end
