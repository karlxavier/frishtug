class Plan < ApplicationRecord
  enum shipping: %i[free paid]
  validates :name, :price, presence: true
  has_many :users
end
