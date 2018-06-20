class AddShippingChargeTypeToPlans < ActiveRecord::Migration[5.1]
  def change
    add_column :plans, :shipping_charge_type, :integer, default: 0
  end
end
