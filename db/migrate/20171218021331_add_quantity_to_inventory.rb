class AddQuantityToInventory < ActiveRecord::Migration[5.1]
  def change
    add_column :inventories, :quantity, :integer
  end
end
