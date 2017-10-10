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
