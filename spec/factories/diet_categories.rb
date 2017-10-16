# == Schema Information
#
# Table name: diet_categories
#
#  id         :integer          not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

FactoryGirl.define do
  factory :diet_category do
    name { Faker::Lorem.word }
  end
end
