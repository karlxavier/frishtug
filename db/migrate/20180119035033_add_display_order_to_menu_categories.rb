class AddDisplayOrderToMenuCategories < ActiveRecord::Migration[5.1]
  def change
    add_column :menu_categories, :display_order, :integer
    add_index :menu_categories, :display_order
  end
end
