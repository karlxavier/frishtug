FactoryGirl.define do
  factory :inventory do
    association :menu, factory: :menu
    quantity Faker::Number.number(3)
    location Faker::Address.city
  end
end
