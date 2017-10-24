class CreateCheckings < ActiveRecord::Migration[5.1]
  def change
    create_table :checkings do |t|
      t.string :bank_name
      t.string :account_number
      t.string :routing_number
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
