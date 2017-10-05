class CreateMenus < ActiveRecord::Migration[5.1]
  def change
    create_table :menus do |t|
      t.string :name
      t.float :price
      t.references :unit, foreign_key: true
      t.references :menu_category, foreign_key: true
      t.references :diet_category, foreign_key: true
      t.datetime :published_at
      t.boolean :published

      t.timestamps
    end
  end
end
