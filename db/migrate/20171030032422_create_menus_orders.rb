class CreateMenusOrders < ActiveRecord::Migration[5.1]
  def change
    create_table :menus_orders do |t|
      t.references :menu, foreign_key: true
      t.references :order, foreign_key: true

      t.timestamps
    end
  end
end
