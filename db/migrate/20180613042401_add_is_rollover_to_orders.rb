class AddIsRolloverToOrders < ActiveRecord::Migration[5.1]
  def change
    add_column :orders, :is_rollover, :boolean, default: false
  end
end
