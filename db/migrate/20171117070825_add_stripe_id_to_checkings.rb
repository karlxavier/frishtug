class AddStripeIdToCheckings < ActiveRecord::Migration[5.1]
  def change
    add_column :checkings, :stripe_id, :string
    add_index :checkings, :stripe_id
  end
end
