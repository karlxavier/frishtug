# frozen_string_literal: true

# == Schema Information
#
# Table name: inventory_transactions
#
#  id               :bigint(8)        not null, primary key
#  inventory_id     :bigint(8)
#  quantity_sold    :integer
#  transaction_date :datetime
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  quantity_on_hand :integer
#

class InventoryTransaction < ApplicationRecord
  belongs_to :inventory
  validates :quantity_sold, :transaction_date, :inventory_id, presence: true
  delegate :quantity, to: :inventory, prefix: true

  class << self
    def between_transaction_date?(range)
      includes(inventory: :menu)
        .where(transaction_date: range.start_date..range.end_date)
    end

    def to_csv
      attributes = %w[item_name quantity_on_hand quantity_sold transaction_date]

      CSV.generate do |csv|
        csv << attributes.map(&:humanize).map(&:titleize)
        all.each do |i|
          csv << attributes.map do |attr|
            if attr == "item_name"
              i.inventory.menu.name
            elsif attr == "transaction_date"
              i.transaction_date.strftime("%B %d, %Y")
            elsif attr == "quantity_on_hand"
              i.inventory_quantity
            else
              i.send(attr)
            end
          end
        end
      end
    end
  end
end
