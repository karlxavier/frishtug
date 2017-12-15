# == Schema Information
#
# Table name: stores
#
#  id               :integer          not null, primary key
#  _id              :integer
#  _code            :string
#  status           :integer
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  home_page_images :text
#

class Store < ApplicationRecord
  validates :_id, presence: true
  has_many :allowed_zip_codes, dependent: :destroy
  has_one :tax, dependent: :destroy

  accepts_nested_attributes_for :tax

  has_uploadcare_group :home_page_images

  def save_zip(zipcodes)
    self.allowed_zip_code_ids = create_zip_from(zipcodes)
  end

  private

  def create_zip_from(zips)
    zips.inject([]) do |arr, zip|
      arr << allowed_zip_codes.find_or_create_by(zip: zip).id
    end
  end
end
