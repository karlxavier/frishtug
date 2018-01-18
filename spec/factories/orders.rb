# == Schema Information
#
# Table name: orders
#
#  id            :integer          not null, primary key
#  user_id       :integer
#  placed_on     :datetime
#  eta           :datetime
#  delivered_at  :datetime
#  status        :integer
#  remarks       :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  order_date    :datetime
#  series_number :integer
#

FactoryBot.define do
  factory :order do
    association :user, factory: :user
    placed_on Faker::Time.between(DateTime.now - 1, DateTime.now)
    eta Faker::Time.between(DateTime.now - 1, DateTime.now)
    delivered_at Faker::Time.between(DateTime.now - 1, DateTime.now)
    status 1
    remarks "Test"
  end
end
