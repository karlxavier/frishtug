# == Schema Information
#
# Table name: menus_temp_orders
#
#  id            :bigint(8)        not null, primary key
#  menu_id       :bigint(8)
#  temp_order_id :bigint(8)
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  quantity      :integer          default(0)
#  add_ons       :string           default([]), is an Array
#

FactoryBot.define do
  factory :menus_temp_order do
    menu nil
    temp_order nil
  end
end
