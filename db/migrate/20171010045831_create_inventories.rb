class CreateInventories < ActiveRecord::Migration[5.1]
  def change
    create_table :inventories do |t|
      t.references :menu, foreign_key: true
      t.integer :quantity
      t.string :location

      t.timestamps
    end
  end
end
