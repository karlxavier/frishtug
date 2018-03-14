# == Schema Information
#
# Table name: pending_credits
#
#  id              :integer          not null, primary key
#  amount          :decimal(8, 2)
#  activation_date :datetime
#  user_id         :integer
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  placed_on_date  :datetime
#

FactoryBot.define do
  factory :pending_credit do
    amount "9.99"
    activation_date "2018-03-06 10:45:27"
    user nil
  end
end
