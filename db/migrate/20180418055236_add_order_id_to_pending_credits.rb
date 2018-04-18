class AddOrderIdToPendingCredits < ActiveRecord::Migration[5.1]
  def change
    add_reference :pending_credits, :order, foreign_key: true
  end
end
