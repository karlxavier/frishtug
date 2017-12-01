class Store < ApplicationRecord
  validates :_id, presence: true
  has_many :allowed_zip_codes, dependent: :destroy

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
