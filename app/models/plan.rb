# Column names
# id name description price shipping shipping_fee
class Plan < ApplicationRecord
  enum shipping: %i[free paid]
  validates :name, :price, presence: true
  has_many :users
end
