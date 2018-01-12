# == Schema Information
#
# Table name: temp_orders
#
#  id         :integer          not null, primary key
#  user_id    :integer
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
