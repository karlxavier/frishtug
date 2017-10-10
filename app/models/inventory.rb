class Inventory < ApplicationRecord
  belongs_to :menu
  has_many :inventory_transactions, dependent: :destroy
  validates :quantity, :menu_id, presence: true
end
