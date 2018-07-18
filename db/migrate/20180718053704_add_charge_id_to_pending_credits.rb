class AddChargeIdToPendingCredits < ActiveRecord::Migration[5.1]
  def change
    add_column :pending_credits, :charge_id, :string
  end
end
