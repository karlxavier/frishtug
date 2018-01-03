class CreateAssetsStores < ActiveRecord::Migration[5.1]
  def change
    create_table :assets_stores do |t|
      t.references :store, foreign_key: true
      t.references :asset, foreign_key: true

      t.timestamps
    end
  end
end
