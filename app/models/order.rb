# Column names
# id user_id placed_on:timestamp eta:timestamp delivered_at:timestamp status:integer
class Order < ApplicationRecord
  enum status: %i[in_transit completed]
  belongs_to :user
  validates :placed_on, :user_id, presence: true
end
