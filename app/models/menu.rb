# Column Names
# id name price unit_id menu_category_id diet_category_id published published_at image
class Menu < ApplicationRecord
  belongs_to :unit
  belongs_to :menu_category
  belongs_to :diet_category, optional: true
  validates :name, :unit_id, :menu_category_id, :price, presence: true
  validates :name, uniqueness: true
  validate :sanitize_price

  mount_uploader :image, ImageUploader

  def sanitize_price
    errors.add(:price, 'should be atleast 0.01') if price.nil? || price < 0.01
  end
end
