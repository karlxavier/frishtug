# == Schema Information
#
# Table name: inventory_transactions
#
#  id               :bigint(8)        not null, primary key
#  inventory_id     :bigint(8)
#  quantity_sold    :integer
#  transaction_date :datetime
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  quantity_on_hand :integer
#

FactoryBot.define do
  factory :inventory_transaction do
    association :inventory, factory: :inventory
    quantity_sold Faker::Number.number(3)
    transaction_date Faker::Time.between(DateTime.now - 1, DateTime.now)
  end
end
