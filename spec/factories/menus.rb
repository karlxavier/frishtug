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
#  unit_size        :integer
#  item_number      :string
#  tax              :boolean          default(FALSE)
#  description      :text
#

FactoryGirl.define do
  factory :menu do
    name { Faker::Food.unique.dish }
    price Faker::Number.decimal(2)
    image Faker::Avatar.image
    association :menu_category, factory: :menu_category
    association :unit, factory: :unit

    trait :with_diet_category do
      association :diet_category, factory: :diet_category
    end

    trait :without_diet_category do
      diet_category_id = nil
    end

    factory :menu_with_diet_category, traits: [:with_diet_category]
    factory :menu_without_diet_category, traits: [:without_diet_category]
  end
end
