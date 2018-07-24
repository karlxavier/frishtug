class CreateContactUsMessages < ActiveRecord::Migration[5.1]
  def change
    create_table :contact_us_messages do |t|
      t.string :first_name
      t.string :last_name
      t.string :email
      t.text :message

      t.timestamps
    end
  end
end
