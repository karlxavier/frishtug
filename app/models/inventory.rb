# == Schema Information
#
# Table name: inventories
#
#  id         :integer          not null, primary key
#  menu_id    :integer
#  quantity   :integer
#  location   :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Inventory < ApplicationRecord
  belongs_to :menu
  has_many :inventory_transactions, dependent: :destroy
  validates :quantity, :menu_id, presence: true
end
