class AddShippingFeeToPlans < ActiveRecord::Migration[5.1]
  def change
    add_column :plans, :shipping_fee, :decimal, precision: 8, scale: 2
  end
end
