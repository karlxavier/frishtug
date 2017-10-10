class CreateInventoryTransactions < ActiveRecord::Migration[5.1]
  def change
    create_table :inventory_transactions do |t|
      t.references :inventory, foreign_key: true
      t.integer :quantity_sold
      t.timestamp :transaction_date

      t.timestamps
    end
  end
end
