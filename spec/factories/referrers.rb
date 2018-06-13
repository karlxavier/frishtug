# == Schema Information
#
# Table name: referrers
#
#  id         :bigint(8)        not null, primary key
#  user_id    :bigint(8)
#  group_code :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

FactoryBot.define do
  factory :referrer do
    user nil
    group_code "MyString"
  end
end
