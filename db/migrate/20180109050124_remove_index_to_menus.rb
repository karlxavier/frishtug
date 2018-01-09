class RemoveIndexToMenus < ActiveRecord::Migration[5.1]
  def change
    remove_index :menus, :name
  end
end
