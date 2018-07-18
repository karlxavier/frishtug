# == Schema Information
#
# Table name: pending_credits
#
#  id              :bigint(8)        not null, primary key
#  amount          :decimal(8, 2)
#  activation_date :datetime
#  user_id         :bigint(8)
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  placed_on_date  :datetime
#  order_id        :bigint(8)
#  charge_id       :string
#

FactoryBot.define do
  factory :pending_credit do
    amount "9.99"
    activation_date "2018-03-06 10:45:27"
    user nil
  end
end
