# == Schema Information
#
# Table name: inactive_users
#
#  id         :integer          not null, primary key
#  first_name :string
#  last_name  :string
#  email      :string
#  status     :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

FactoryBot.define do
  factory :inactive_user do
    first_name "MyString"
    last_name "MyString"
    email "MyString"
    status 1
  end
end
