class Referrer < ApplicationRecord
  belongs_to :user
  has_many :candidates
  validates :group_code, presence: true
end
