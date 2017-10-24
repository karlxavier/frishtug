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
#

# Column names
# id line1 line2 front_door city state zip_code addressable_type addressable_id
class Address < ApplicationRecord
  enum location_at: %i[at_work at_home multiple_workplaces]
  belongs_to :addressable, polymorphic: true
  validates :line1, :city, :state, :zip_code, presence: true
end
