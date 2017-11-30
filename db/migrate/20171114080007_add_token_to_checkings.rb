class AddTokenToCheckings < ActiveRecord::Migration[5.1]
  def change
    add_column :checkings, :token, :string
    add_index :checkings, :token
  end
end
