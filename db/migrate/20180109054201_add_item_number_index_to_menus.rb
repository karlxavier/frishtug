class AddItemNumberIndexToMenus < ActiveRecord::Migration[5.1]
  def change
    add_index :menus, [:item_number], unique: true
  end
end
