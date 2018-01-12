# == Schema Information
#
# Table name: inventory_transactions
#
#  id               :integer          not null, primary key
#  inventory_id     :integer
#  quantity_sold    :integer
#  transaction_date :datetime
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#

FactoryBot.define do
  factory :inventory_transaction do
    association :inventory, factory: :inventory
    quantity_sold Faker::Number.number(3)
    transaction_date Faker::Time.between(DateTime.now - 1, DateTime.now)
  end
end
