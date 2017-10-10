class CreateOrders < ActiveRecord::Migration[5.1]
  def change
    create_table :orders do |t|
      t.references :user, foreign_key: true
      t.timestamp :placed_on
      t.timestamp :eta
      t.timestamp :delivered_at
      t.integer :status
      t.string :remarks

      t.timestamps
    end
  end
end
