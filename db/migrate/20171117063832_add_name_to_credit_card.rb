class AddNameToCreditCard < ActiveRecord::Migration[5.1]
  def change
    add_column :credit_cards, :name, :string
  end
end
