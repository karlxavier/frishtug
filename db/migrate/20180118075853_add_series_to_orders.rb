class AddSeriesToOrders < ActiveRecord::Migration[5.1]
  def change
    add_column :orders, :series_number, :integer
    add_index :orders, :series_number
  end
end
