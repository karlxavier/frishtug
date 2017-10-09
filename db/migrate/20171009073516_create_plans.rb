class CreatePlans < ActiveRecord::Migration[5.1]
  def change
    create_table :plans do |t|
      t.string :name
      t.text :description
      t.decimal :price, precision: 8, scale: 2
      t.string :shipping_fee
      t.integer :shipping

      t.timestamps
    end
  end
end
