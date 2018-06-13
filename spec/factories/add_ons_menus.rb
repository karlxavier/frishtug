# == Schema Information
#
# Table name: add_ons_menus
#
#  id         :bigint(8)        not null, primary key
#  add_on_id  :bigint(8)
#  menu_id    :bigint(8)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

FactoryBot.define do
  factory :add_ons_menu do
    add_on nil
    menu nil
  end
end
