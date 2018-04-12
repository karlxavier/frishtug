class CreateUserNotifications < ActiveRecord::Migration[5.1]
  def change
    create_table :user_notifications do |t|
      t.string :title
      t.text :body
      t.integer :timeout
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
