class AddRemarksToPendingCredits < ActiveRecord::Migration[5.1]
  def change
    add_column :pending_credits, :remarks, :string
  end
end
