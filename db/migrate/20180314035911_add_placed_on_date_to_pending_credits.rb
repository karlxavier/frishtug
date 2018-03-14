class AddPlacedOnDateToPendingCredits < ActiveRecord::Migration[5.1]
  def change
    add_column :pending_credits, :placed_on_date, :timestamp
  end
end
