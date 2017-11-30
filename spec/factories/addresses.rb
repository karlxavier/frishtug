# == Schema Information
#
# Table name: addresses
#
#  id               :integer          not null, primary key
#  line1            :string
#  line2            :string
#  front_door       :string
#  city             :string
#  state            :string
#  zip_code         :string
#  addressable_type :string
#  addressable_id   :integer
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  location_at      :integer
#  latitude         :float
#  longitude        :float
#  status           :integer
#

FactoryGirl.define do
  factory :address do
    line1 "MyString"
    line2 "MyString"
    front_door "MyString"
    city "MyString"
    state "MyString"
    zip_code "MyString"
  end
end
