# == Schema Information
#
# Table name: inventories
#
#  id         :integer          not null, primary key
#  menu_id    :integer
#  quantity   :integer
#  location   :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

FactoryGirl.define do
  factory :inventory do
    association :menu, factory: :menu
    quantity Faker::Number.number(3)
    location Faker::Address.city
  end
end
