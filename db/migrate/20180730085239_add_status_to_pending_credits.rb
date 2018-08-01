class AddStatusToPendingCredits < ActiveRecord::Migration[5.1]
  def change
    add_column :pending_credits, :status, :integer, default: 0
  end
end
