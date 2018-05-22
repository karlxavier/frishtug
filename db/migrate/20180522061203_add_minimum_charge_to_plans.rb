class AddMinimumChargeToPlans < ActiveRecord::Migration[5.1]
  def change
    add_column :plans, :minimum_charge, :decimal, precision: 8, scale: 2, default: 0
  end
end
