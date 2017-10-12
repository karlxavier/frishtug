# == Schema Information
#
# Table name: menu_categories
#
#  id         :integer          not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

# Column names
# id name
class MenuCategory < ApplicationRecord
  validates :name, presence: true
  validates :name, uniqueness: true
  has_many :menus, dependent: :destroy
  has_many :add_ons, dependent: :destroy

  accepts_nested_attributes_for :add_ons, allow_destroy: true
end
