class CreateShippingPrices < ActiveRecord::Migration[5.1]
  def change
    create_table :shipping_prices do |t|
      t.string :zip
      t.decimal :price, precision: 8, scale: 0

      t.timestamps
    end
    add_index :shipping_prices, :zip
  end
end
