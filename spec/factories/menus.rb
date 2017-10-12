# == Schema Information
#
# Table name: menus
#
#  id               :integer          not null, primary key
#  name             :string
#  price            :decimal(8, 2)
#  unit_id          :integer
#  menu_category_id :integer
#  diet_category_id :integer
#  published_at     :datetime
#  published        :boolean
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  image            :string
#

FactoryGirl.define do
  factory :menu do
    name Faker::Food.dish
    price Faker::Number.decimal(2)
    image Faker::Avatar.image
    association :menu_category, factory: :menu_category
    association :diet_category, factory: :diet_category
    association :unit, factory: :unit
  end
end
