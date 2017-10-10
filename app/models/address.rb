# Column names
# id line1 line2 front_door city state zip_code addressable_type addressable_id
class Address < ApplicationRecord
  belongs_to :addressable, polymorphic: true
  validates :line1, :city, :state, :zip_code, presence: true
end
