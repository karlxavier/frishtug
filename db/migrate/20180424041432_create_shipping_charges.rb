class CreateShippingCharges < ActiveRecord::Migration[5.1]
  def change
    create_table :shipping_charges do |t|
      t.references :order, foreign_key: true
      t.string :charge_id

      t.timestamps
    end
  end
end
