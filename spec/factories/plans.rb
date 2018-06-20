# == Schema Information
#
# Table name: plans
#
#  id                     :bigint(8)        not null, primary key
#  name                   :string
#  description            :text
#  price                  :decimal(8, 2)
#  shipping               :integer
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  shipping_fee           :decimal(8, 2)
#  note                   :text
#  shipping_note          :string
#  stripe_plan_id         :string
#  interval               :string
#  users_count            :integer          default(0)
#  for_type               :string
#  short_description      :string(150)
#  limit                  :decimal(8, 2)
#  minimum_credit_allowed :decimal(8, 2)
#  minimum_charge         :decimal(8, 2)    default(0.0)
#  shipping_charge_type   :integer          default(0)
#

FactoryBot.define do
  factory :plan do
    name 'Option 1'
    description Faker::Lorem.sentences
    price Faker::Number.decimal(2)
    shipping_fee Faker::Number.decimal(2)
    shipping :free
  end
end
