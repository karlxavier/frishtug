class AddShortDescriptionToPlans < ActiveRecord::Migration[5.1]
  def change
    add_column :plans, :short_description, :string, limit: 150
  end
end
