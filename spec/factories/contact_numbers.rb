# == Schema Information
#
# Table name: contact_numbers
#
#  id           :bigint(8)        not null, primary key
#  phone_number :string
#  user_id      :bigint(8)
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

FactoryBot.define do
  factory :contact_number do
    phone_number "MyString"
    user nil
  end
end
