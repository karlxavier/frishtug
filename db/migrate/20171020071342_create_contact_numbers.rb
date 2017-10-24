class CreateContactNumbers < ActiveRecord::Migration[5.1]
  def change
    create_table :contact_numbers do |t|
      t.string :phone_number
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
