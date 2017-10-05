class CreateAddOns < ActiveRecord::Migration[5.1]
  def change
    create_table :add_ons do |t|
      t.string :name
      t.references :menu_category, foreign_key: true

      t.timestamps
    end
  end
end
