# == Schema Information
#
# Table name: referrers
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  group_code :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

FactoryGirl.define do
  factory :referrer do
    user nil
    group_code "MyString"
  end
end
