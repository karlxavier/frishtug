# == Schema Information
#
# Table name: blackout_dates
#
#  id          :bigint(8)        not null, primary key
#  month       :string
#  day         :integer
#  description :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

FactoryBot.define do
  factory :blackout_date do
    month "MyString"
    day 1
    description "MyString"
  end
end
