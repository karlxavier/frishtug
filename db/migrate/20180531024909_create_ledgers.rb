class CreateLedgers < ActiveRecord::Migration[5.1]
  def change
    create_table :ledgers do |t|
      t.decimal :amount, precision: 8, scale: 2
      t.references :order, foreign_key: true
      t.string :type
      t.references :user, foreign_key: true
      t.integer :status

      t.timestamps
    end
    add_index :ledgers, :type
  end
end
