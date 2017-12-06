class RemoveQuantityFromInventory < ActiveRecord::Migration[5.1]
  def change
    remove_column :inventories, :quantity, :integer
  end
end
