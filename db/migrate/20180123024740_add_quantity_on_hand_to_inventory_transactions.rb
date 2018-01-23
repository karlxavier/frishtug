class AddQuantityOnHandToInventoryTransactions < ActiveRecord::Migration[5.1]
  def change
    add_column :inventory_transactions, :quantity_on_hand, :integer
  end
end
