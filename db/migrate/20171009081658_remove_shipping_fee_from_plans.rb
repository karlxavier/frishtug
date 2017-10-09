class RemoveShippingFeeFromPlans < ActiveRecord::Migration[5.1]
  def change
    remove_column :plans, :shipping_fee, :string
  end
end
