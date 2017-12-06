# == Schema Information
#
# Table name: inventory_transactions
#
#  id               :integer          not null, primary key
#  inventory_id     :integer
#  quantity_sold    :integer
#  transaction_date :datetime
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#

class InventoryTransaction < ApplicationRecord
  belongs_to :inventory
  validates :quantity_sold, :transaction_date, :inventory_id, presence: true

  class << self
    def between_transaction_date?(range)
      where(transaction_date: range.start_date..range.end_date)
    end
  end
end
