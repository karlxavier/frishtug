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
#  quantity_on_hand :integer
#

class InventoryTransaction < ApplicationRecord
  belongs_to :inventory
  validates :quantity_sold, :transaction_date, :inventory_id, presence: true

  class << self
    def between_transaction_date?(range)
      includes(inventory: :menu)
        .where(transaction_date: range.start_date..range.end_date)
    end

    def to_csv
      attributes = %w[inventory_id item_name quantity_sold transaction_date]

      CSV.generate do |csv|
        csv << attributes.map(&:humanize).map(&:titleize)
        all.each do |i|
          csv << attributes.map do |attr|
            if attr == 'item_name'
              i.inventory.menu.name
            else
              i.send(attr)
            end
          end
        end
      end
    end
  end
end
