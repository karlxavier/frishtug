class Menu < ApplicationRecord
  belongs_to :unit
  belongs_to :menu_category
  belongs_to :diet_category
  validates :name, :unit_id, :menu_category_id, :price, presence: true
  validates :name, uniqueness: true

  mount_uploader :image, ImageUploader
end
