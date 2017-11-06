class AddBrandToCreditCards < ActiveRecord::Migration[5.1]
  def change
    add_column :credit_cards, :brand, :string
  end
end
