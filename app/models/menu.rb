class Menu < ApplicationRecord
  belongs_to :unit
  belongs_to :menu_category
  belongs_to :diet_category

  mount_uploader :image, ImageUploader
end
