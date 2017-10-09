class AddOn < ApplicationRecord
  belongs_to :menu_category
  validates :name, :menu_category_id, presence: true
end
