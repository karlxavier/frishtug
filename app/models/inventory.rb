# == Schema Information
#
# Table name: inventories
#
#  id           :bigint(8)        not null, primary key
#  menu_id      :bigint(8)
#  location     :string
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  inventory_id :string
#  quantity     :integer
#

class Inventory < ApplicationRecord
  belongs_to :menu
  has_many :inventory_transactions, dependent: :destroy
  validates :menu_id, uniqueness: true
  before_save :create_inventory_id

  private

  def create_inventory_id
    self.inventory_id = SecureRandom.urlsafe_base64(10)
  end
end
