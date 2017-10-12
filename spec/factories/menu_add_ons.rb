# == Schema Information
#
# Table name: menu_add_ons
#
#  id         :integer          not null, primary key
#  menu_id    :integer
#  add_on_id  :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

FactoryGirl.define do
  factory :menu_add_on do
    menu nil
    add_on nil
  end
end
