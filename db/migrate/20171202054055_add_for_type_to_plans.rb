class AddForTypeToPlans < ActiveRecord::Migration[5.1]
  def change
    add_column :plans, :for_type, :string
  end
end
