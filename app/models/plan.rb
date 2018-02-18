# == Schema Information
#
# Table name: plans
#
#  id                     :integer          not null, primary key
#  name                   :string
#  description            :text
#  price                  :decimal(8, 2)
#  shipping               :integer
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  shipping_fee           :decimal(8, 2)
#  note                   :text
#  shipping_note          :string
#  stripe_plan_id         :string
#  interval               :string
#  users_count            :integer          default(0)
#  for_type               :string
#  short_description      :string(150)
#  limit                  :decimal(8, 2)
#  minimum_credit_allowed :decimal(8, 2)
#

# Column names
# id name description price shipping shipping_fee
class Plan < ApplicationRecord
  include Subscribable
  enum shipping: %i[free paid]
  validates :name, :price, presence: true
  validates :name, uniqueness: true
  scope :subscriptions, -> { where(interval: 'month') }
  has_many :users
  has_many :comments, as: :commentable, dependent: :destroy

  def self.best_seller
    order(users_count: :desc).limit(1).first
  end

  def types
    [['Individual', 'individual'], ['Group', 'group']]
  end

  def group?
    self[:for_type] == 'group'
  end

  def individual?
    self[:for_type] == 'individual'
  end
end
