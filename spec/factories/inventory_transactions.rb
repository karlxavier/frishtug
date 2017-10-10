FactoryGirl.define do
  factory :inventory_transaction do
    association :inventory, factory: :inventory
    quantity_sold Faker::Number.number(3)
    transaction_date Faker::Time.between(DateTime.now - 1, DateTime.now)
  end
end
