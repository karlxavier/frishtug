# == Schema Information
#
# Table name: menus_orders
#
#  id         :bigint(8)        not null, primary key
#  menu_id    :bigint(8)
#  order_id   :bigint(8)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  quantity   :integer
#  add_ons    :string           default([]), is an Array
#

FactoryBot.define do
  factory :menus_order do
    menu nil
    order nil
  end
end
