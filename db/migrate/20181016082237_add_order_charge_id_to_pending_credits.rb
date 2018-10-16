class AddOrderChargeIdToPendingCredits < ActiveRecord::Migration[5.1]
  def change
    add_column :pending_credits, :order_charge_id, :string
  end
end
