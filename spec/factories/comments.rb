FactoryGirl.define do
  factory :comment do
    user nil
    body "MyText"
    commentable nil
  end
end
