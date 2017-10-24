class CreateCreditCards < ActiveRecord::Migration[5.1]
  def change
    create_table :credit_cards do |t|
      t.string :number
      t.integer :month, limit: 2
      t.integer :year, limit: 2
      t.integer :cvc, limit: 4
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
