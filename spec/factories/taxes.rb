# == Schema Information
#
# Table name: taxes
#
#  id         :bigint(8)        not null, primary key
#  rate       :float
#  store_id   :bigint(8)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

FactoryBot.define do
  factory :tax do
    rate 1.5
    store nil
  end
end
