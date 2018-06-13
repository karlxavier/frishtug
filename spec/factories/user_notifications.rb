# == Schema Information
#
# Table name: user_notifications
#
#  id         :bigint(8)        not null, primary key
#  title      :string
#  body       :text
#  timeout    :integer
#  user_id    :bigint(8)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  uniq_id    :string
#

FactoryBot.define do
  factory :user_notification do
    title "MyString"
    body "MyText"
    timeout 1
    user nil
  end
end
