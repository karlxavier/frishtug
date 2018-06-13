# == Schema Information
#
# Table name: add_ons
#
#  id               :bigint(8)        not null, primary key
#  name             :string
#  menu_category_id :bigint(8)
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  menu_id          :bigint(8)
#

FactoryBot.define do
  factory :add_on do
    name { Faker::Lorem.unique.word }
    menu_category nil
  end
end
