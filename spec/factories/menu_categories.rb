# == Schema Information
#
# Table name: menu_categories
#
#  id            :bigint(8)        not null, primary key
#  name          :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  display_order :integer
#  part_of_plan  :boolean          default(TRUE)
#

FactoryBot.define do
  factory :menu_category do
    name { Faker::Food.dish }

    trait :unique do
      name { Faker::Food.unique.dish }
    end

    factory :menu_category_unique, traits: [:unique]
  end
end
