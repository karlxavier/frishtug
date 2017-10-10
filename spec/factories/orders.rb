FactoryGirl.define do
  factory :order do
    association :user, factory: :user
    placed_on Faker::Time.between(DateTime.now - 1, DateTime.now)
    eta Faker::Time.between(DateTime.now - 1, DateTime.now)
    delivered_at Faker::Time.between(DateTime.now - 1, DateTime.now)
    status 1
    remarks "Test"
  end
end
