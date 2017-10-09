FactoryGirl.define do
  factory :plan do
    name 'Option 1'
    description Faker::Lorem.sentences
    price Faker::Number.decimal(2)
    shipping_fee Faker::Number.decimal(2)
    shipping :free
  end
end
