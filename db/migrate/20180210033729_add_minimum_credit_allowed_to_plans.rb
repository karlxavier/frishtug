class AddMinimumCreditAllowedToPlans < ActiveRecord::Migration[5.1]
  def change
    add_column :plans, :minimum_credit_allowed, :decimal, precision: 8, scale: 2
  end
end
