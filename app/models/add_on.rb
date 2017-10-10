# Class names
# id name menu_category_id
class AddOn < ApplicationRecord
  belongs_to :menu_category
  validates :name, :menu_category_id, presence: true
end
