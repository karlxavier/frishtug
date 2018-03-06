class CreatePendingCredits < ActiveRecord::Migration[5.1]
  def change
    create_table :pending_credits do |t|
      t.decimal :amount, precision: 8, scale: 2
      t.datetime :activation_date
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
