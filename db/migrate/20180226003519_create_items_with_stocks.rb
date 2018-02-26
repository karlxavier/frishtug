class CreateItemsWithStocks < ActiveRecord::Migration[5.1]
  def change
    create_view :items_with_stocks, materialized: true
    add_index :items_with_stocks, :menu_id
    add_index :items_with_stocks, :asset_id
    add_index :items_with_stocks, :menu_category_id
  end
end
