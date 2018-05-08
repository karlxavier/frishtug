class AddUniqIdToUserNotifications < ActiveRecord::Migration[5.1]
  def change
    add_column :user_notifications, :uniq_id, :string
    add_index :user_notifications, :uniq_id
  end
end
