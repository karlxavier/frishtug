class AddColumnsToMenus < ActiveRecord::Migration[5.1]
  def change
    add_column :menus, :unit_size, :integer
    add_column :menus, :item_number, :string, index: true
    add_column :menus, :tax, :boolean, default: false
  end
end
