class AddInventoryIdToInventory < ActiveRecord::Migration[5.1]
  def change
    add_column :inventories, :inventory_id, :string
    add_index :inventories, :inventory_id
  end
end
