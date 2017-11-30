class AddIndexToMenus < ActiveRecord::Migration[5.1]
  def change
    add_index :menus, [:name], unique: true
  end
end
