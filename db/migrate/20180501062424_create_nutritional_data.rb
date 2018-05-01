class CreateNutritionalData < ActiveRecord::Migration[5.1]
  def change
    create_table :nutritional_data do |t|
      t.references :menu, foreign_key: true
      t.jsonb :data

      t.timestamps
    end
  end
end
