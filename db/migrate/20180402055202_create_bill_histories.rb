class CreateBillHistories < ActiveRecord::Migration[5.1]
  def change
    create_table :bill_histories do |t|
      t.references :order, foreign_key: true
      t.references :user, foreign_key: true
      t.decimal :amount_paid, precision: 8, scale: 2
      t.datetime :billed_at
      t.string :description

      t.timestamps
    end
  end
end
