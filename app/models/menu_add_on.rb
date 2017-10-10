# Join table for menu and add-ons
# Class names
# id menu_id add_on_id
class MenuAddOn < ApplicationRecord
  belongs_to :menu
  belongs_to :add_on
  validates :menu_id, :add_on_id, presence: true
end
