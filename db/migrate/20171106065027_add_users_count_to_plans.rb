class AddUsersCountToPlans < ActiveRecord::Migration[5.1]
  def change
    add_column :plans, :users_count, :integer, default: 0
  end
end
