class AddColumnsToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :stripe_token, :string
    add_index :users, :stripe_token
    add_column :users, :subscribe_at, :datetime
    add_index :users, :subscribe_at
    add_column :users, :subscription_expires_at, :datetime
    add_index :users, :subscription_expires_at
    add_column :users, :stripe_customer_id, :string
    add_index :users, :stripe_customer_id
  end
end
