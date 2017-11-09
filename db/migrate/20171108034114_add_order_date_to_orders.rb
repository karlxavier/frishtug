class AddOrderDateToOrders < ActiveRecord::Migration[5.1]
  def change
    add_column :orders, :order_date, :datetime
    add_index :orders, :order_date
  end
end
