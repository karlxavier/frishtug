# == Schema Information
#
# Table name: shipping_charges
#
#  id         :integer          not null, primary key
#  order_id   :integer
#  charge_id  :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

FactoryBot.define do
  factory :shipping_charge do
    order nil
    charge_id "MyString"
  end
end
