# == Schema Information
#
# Table name: taxes
#
#  id         :integer          not null, primary key
#  rate       :float
#  store_id   :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

FactoryGirl.define do
  factory :tax do
    rate 1.5
    store nil
  end
end
