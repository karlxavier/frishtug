# == Schema Information
#
# Table name: plans
#
#  id             :integer          not null, primary key
#  name           :string
#  description    :text
#  price          :decimal(8, 2)
#  shipping       :integer
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  shipping_fee   :decimal(8, 2)
#  note           :text
#  shipping_note  :string
#  stripe_plan_id :string
#  interval       :string
#  users_count    :integer          default(0)
#

# Column names
# id name description price shipping shipping_fee
class Plan < ApplicationRecord
  enum shipping: %i[free paid]
  validates :name, :price, presence: true
  validates :name, uniqueness: true
  has_many :users
  has_many :comments, as: :commentable, dependent: :destroy
end
