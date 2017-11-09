class CreateStores < ActiveRecord::Migration[5.1]
  def change
    create_table :stores do |t|
      t.integer :_id
      t.string :_code
      t.integer :status

      t.timestamps
    end
  end
end
