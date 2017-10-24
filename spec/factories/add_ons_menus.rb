# == Schema Information
#
# Table name: add_ons_menus
#
#  id         :integer          not null, primary key
#  add_on_id  :integer
#  menu_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

FactoryGirl.define do
  factory :add_ons_menu do
    add_on nil
    menu nil
  end
end
