class AddPaymentStatusToOrders < ActiveRecord::Migration[5.1]
  def change
    add_column :orders, :payment_status, :integer
  end
end
