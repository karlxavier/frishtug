# == Schema Information
#
# Table name: bill_histories
#
#  id          :bigint(8)        not null, primary key
#  order_id    :bigint(8)
#  user_id     :bigint(8)
#  amount_paid :decimal(8, 2)
#  billed_at   :datetime
#  description :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

FactoryBot.define do
  factory :bill_history do
    order nil
    user nil
    amount_paid "9.99"
    billed_at "2018-04-02 13:52:03"
    description "MyString"
  end
end
