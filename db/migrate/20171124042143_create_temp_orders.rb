class CreateTempOrders < ActiveRecord::Migration[5.1]
  def change
    create_table :temp_orders do |t|
      t.references :user, foreign_key: true
      t.timestamp :order_date

      t.timestamps
    end
  end
end
