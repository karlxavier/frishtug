# == Schema Information
#
# Table name: notifications
#
#  id         :bigint(8)        not null, primary key
#  title      :string
#  body       :text
#  expiry     :datetime
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

FactoryBot.define do
  factory :notification do
    title "MyString"
    body "MyText"
    expiry "2018-08-02 16:20:07"
  end
end
