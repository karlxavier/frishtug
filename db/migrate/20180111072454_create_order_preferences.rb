class CreateOrderPreferences < ActiveRecord::Migration[5.1]
  def change
    create_table :order_preferences do |t|
      t.boolean :copy_menu
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
