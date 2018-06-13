# == Schema Information
#
# Table name: inventories
#
#  id           :bigint(8)        not null, primary key
#  menu_id      :bigint(8)
#  location     :string
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  inventory_id :string
#  quantity     :integer
#

FactoryBot.define do
  factory :inventory do
    association :menu, factory: :menu
    quantity Faker::Number.number(3)
    location Faker::Address.city
  end
end
