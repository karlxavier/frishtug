FactoryGirl.define do
  factory :menu do
    name Faker::Food.dish
    price Faker::Number.decimal(2)
    image Faker::Avatar.image
    menu_category_id nil
  end
end
