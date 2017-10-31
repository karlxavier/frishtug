# == Schema Information
#
# Table name: plans
#
#  id            :integer          not null, primary key
#  name          :string
#  description   :text
#  price         :decimal(8, 2)
#  shipping      :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  shipping_fee  :decimal(8, 2)
#  note          :text
#  shipping_note :string
#

# Column names
# id name description price shipping shipping_fee
class Plan < ApplicationRecord
  enum shipping: %i[free paid]
  validates :name, :price, presence: true
  validates :name, uniqueness: true
  has_many :users
end
