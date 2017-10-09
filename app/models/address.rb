class Address < ApplicationRecord
  belongs_to :addressable, polymorphic: true
  validates :line1, :city, :state, :zip_code, presence: true
end
