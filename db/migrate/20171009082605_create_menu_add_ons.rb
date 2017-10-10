class CreateMenuAddOns < ActiveRecord::Migration[5.1]
  def change
    create_table :menu_add_ons do |t|
      t.references :menu, foreign_key: true
      t.references :add_on, foreign_key: true

      t.timestamps
    end
  end
end
