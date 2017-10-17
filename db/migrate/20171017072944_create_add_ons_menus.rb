class CreateAddOnsMenus < ActiveRecord::Migration[5.1]
  def change
    create_table :add_ons_menus do |t|
      t.references :add_on, foreign_key: true
      t.references :menu, foreign_key: true

      t.timestamps
    end
  end
end
