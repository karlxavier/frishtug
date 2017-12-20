# == Schema Information
#
# Table name: inventories
#
#  id           :integer          not null, primary key
#  menu_id      :integer
#  location     :string
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  inventory_id :string
#  quantity     :integer
#

class Inventory < ApplicationRecord
  belongs_to :menu
  has_many :inventory_transactions, dependent: :destroy
end
