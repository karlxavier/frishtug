# == Schema Information
#
# Table name: suggestion_complaints
#
#  id         :integer          not null, primary key
#  email      :string
#  message    :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  type       :integer          default(NULL)
#

FactoryBot.define do
  factory :suggestion_complaint do
    type ""
    email "MyString"
    message "MyString"
  end
end
