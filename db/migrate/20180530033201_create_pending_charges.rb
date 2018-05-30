class CreatePendingCharges < ActiveRecord::Migration[5.1]
  def change
    create_table :pending_charges do |t|
      t.decimal :amount, precision: 8, scale: 2
      t.string :remarks
      t.string :type
      t.references :user, foreign_key: true

      t.timestamps
    end
    add_index :pending_charges, :type
  end
end
