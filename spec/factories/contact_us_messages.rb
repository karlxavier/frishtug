# == Schema Information
#
# Table name: contact_us_messages
#
#  id         :bigint(8)        not null, primary key
#  first_name :string
#  last_name  :string
#  email      :string
#  message    :text
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

FactoryBot.define do
  factory :contact_us_message do
    first_name "MyString"
    last_name "MyString"
    email "MyString"
    message "MyText"
  end
end
