# == Schema Information
#
# Table name: orders
#
#  id           :integer          not null, primary key
#  user_id      :integer
#  placed_on    :datetime
#  eta          :datetime
#  delivered_at :datetime
#  status       :integer
#  remarks      :string
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

# Column names
# id user_id placed_on:timestamp eta:timestamp delivered_at:timestamp status:integer
class Order < ApplicationRecord
  enum status: %i[in_transit completed]
  belongs_to :user
  validates :placed_on, :user_id, presence: true
end
