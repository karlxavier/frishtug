class AddDisplayOrderToMenus < ActiveRecord::Migration[5.1]
  def change
    add_column :menus, :display_order, :integer
    add_index :menus, :display_order
  end
end
