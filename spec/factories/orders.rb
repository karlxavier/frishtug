FactoryGirl.define do
  factory :order do
    user nil
    placed_on ""
    eta ""
    delivered_at ""
    status 1
    remarks "MyString"
  end
end
