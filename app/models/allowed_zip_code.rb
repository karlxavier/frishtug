# == Schema Information
#
# Table name: allowed_zip_codes
#
#  id         :integer          not null, primary key
#  zip        :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class AllowedZipCode < ApplicationRecord
  validates :zip, uniqueness: true
  validates :zip, presence: true

  before_save :remove_leading_and_ending_space

  def remove_leading_and_ending_space
    self[:zip] = self[:zip].strip
  end
end
