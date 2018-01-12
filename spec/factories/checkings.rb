# == Schema Information
#
# Table name: checkings
#
#  id             :integer          not null, primary key
#  bank_name      :string
#  account_number :string
#  routing_number :string
#  user_id        :integer
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  token          :string
#  stripe_id      :string
#

FactoryBot.define do
  factory :checking do
    bank_name "MyString"
    account_number "MyString"
    routing_number "MyString"
    user nil
  end
end
