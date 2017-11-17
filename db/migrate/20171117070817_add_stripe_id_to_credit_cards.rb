class AddStripeIdToCreditCards < ActiveRecord::Migration[5.1]
  def change
    add_column :credit_cards, :stripe_id, :string
    add_index :credit_cards, :stripe_id
  end
end
