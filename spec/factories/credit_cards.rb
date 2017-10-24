FactoryGirl.define do
  factory :credit_card do
    number "MyString"
    month 1
    year 1
    cvc 1
    user nil
  end
end
