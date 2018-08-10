class ShippingPrice < ApplicationRecord
  validates :zip, :price, presence: true
  validates :zip, uniqueness: true
  validates_format_of :zip, with: /\A\d{5}\z/, message: "should be in the format of 12345"
  before_save :sanitize_zip
  after_create_commit :create_shipping_charges

  private

  def sanitize_zip
    self.zip.strip
  end

  def create_shipping_charges
    ShippingChargeWorker.perform_async(self.id)
  end
end
