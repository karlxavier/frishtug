# == Schema Information
#
# Table name: ledgers
#
#  id         :bigint(8)        not null, primary key
#  amount     :decimal(8, 2)
#  order_id   :bigint(8)
#  type       :string
#  user_id    :bigint(8)
#  status     :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  charge_id  :string
#

FactoryBot.define do
  factory :ledger do
    amount "9.99"
    order nil
    type ""
    user nil
    status 1
  end
end
