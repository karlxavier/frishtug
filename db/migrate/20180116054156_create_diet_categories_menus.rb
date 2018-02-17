class CreateDietCategoriesMenus < ActiveRecord::Migration[5.1]
  def change
    create_table :diet_categories_menus do |t|
      t.references :diet_category
      t.references :menu

      t.timestamps
    end
  end
end
