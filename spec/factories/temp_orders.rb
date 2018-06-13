# == Schema Information
#
# Table name: temp_orders
#
#  id         :bigint(8)        not null, primary key
#  user_id    :bigint(8)
#  order_date :datetime
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

FactoryBot.define do
  factory :temp_order do
    user nil
    order_date "2017-11-24 12:21:43"
  end
end
