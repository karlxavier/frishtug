# == Schema Information
#
# Table name: addresses
#
#  id               :bigint(8)        not null, primary key
#  line1            :string
#  line2            :string
#  front_door       :string
#  city             :string
#  state            :string
#  zip_code         :string
#  addressable_type :string
#  addressable_id   :bigint(8)
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  location_at      :integer
#  status           :integer
#  latitude         :float
#  longitude        :float
#

FactoryBot.define do
  factory :address do
    line1 "MyString"
    line2 "MyString"
    front_door "MyString"
    city "MyString"
    state "MyString"
    zip_code "MyString"
  end
end
