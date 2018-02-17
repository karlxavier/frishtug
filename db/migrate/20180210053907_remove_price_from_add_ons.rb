class RemovePriceFromAddOns < ActiveRecord::Migration[5.1]
  def change
    remove_column :add_ons, :price, :decimal
  end
end
