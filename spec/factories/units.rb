# == Schema Information
#
# Table name: units
#
#  id         :bigint(8)        not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

FactoryBot.define do
  factory :unit do
    name { Faker::Food.metric_measurement }

    trait :unique do
      name { Faker::Food.unique.metric_measurement }
    end

    factory :unit_unique, traits: [:unique]
  end
end
