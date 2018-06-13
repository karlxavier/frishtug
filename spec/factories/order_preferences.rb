# == Schema Information
#
# Table name: order_preferences
#
#  id         :bigint(8)        not null, primary key
#  copy_menu  :boolean
#  user_id    :bigint(8)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

FactoryBot.define do
  factory :order_preference do
    copy_menu false
    user nil
  end
end
