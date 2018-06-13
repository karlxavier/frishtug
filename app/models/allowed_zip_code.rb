# == Schema Information
#
# Table name: allowed_zip_codes
#
#  id         :bigint(8)        not null, primary key
#  zip        :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  store_id   :bigint(8)
#

class AllowedZipCode < ApplicationRecord
  validates :zip, uniqueness: true
  validates :zip, presence: true
  belongs_to :store
  before_save :remove_leading_and_ending_space

  def remove_leading_and_ending_space
    self[:zip] = self[:zip].strip
  end
end
