class AddColumnsToOrders < ActiveRecord::Migration[5.1]
  def change
    add_column :orders, :payment_details, :string
    add_column :orders, :route_started, :string
  end
end
