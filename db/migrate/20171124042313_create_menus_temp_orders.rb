class CreateMenusTempOrders < ActiveRecord::Migration[5.1]
  def change
    create_table :menus_temp_orders do |t|
      t.references :menu, foreign_key: true
      t.references :temp_order, foreign_key: true

      t.timestamps
    end
  end
end
