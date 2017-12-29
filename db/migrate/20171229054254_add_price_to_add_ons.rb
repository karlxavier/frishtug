class AddPriceToAddOns < ActiveRecord::Migration[5.1]
  def change
    add_column :add_ons, :price, :decimal, precision: 8, scale: 2
  end
end
