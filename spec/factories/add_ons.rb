# == Schema Information
#
# Table name: add_ons
#
#  id               :integer          not null, primary key
#  name             :string
#  menu_category_id :integer
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#

FactoryGirl.define do
  factory :add_on do
    name Faker::Lorem.word
    menu_category nil
  end
end
