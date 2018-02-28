class CreateInactiveUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :inactive_users do |t|
      t.string :first_name
      t.string :last_name
      t.string :email
      t.integer :status

      t.timestamps
    end
  end
end
