class InventoryTransaction < ApplicationRecord
  belongs_to :inventory
  validates :quantity_sold, :transaction_date, :inventory_id, presence: true
end
