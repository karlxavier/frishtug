class UpdateItemsWithStocksToVersion2 < ActiveRecord::Migration[5.1]
  def change
    update_view :items_with_stocks,
      version: 2,
      revert_to_version: 1,
      materialized: true
  end
end
