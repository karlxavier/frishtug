class AddColumnsToPlans < ActiveRecord::Migration[5.1]
  def change
    add_column :plans, :stripe_plan_id, :string
    add_index :plans, :stripe_plan_id
    add_column :plans, :interval, :string
  end
end
