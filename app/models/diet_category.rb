class DietCategory < ApplicationRecord
  validates :name, presence: true
  validates :name, uniqueness: true
  has_many :menus
end
