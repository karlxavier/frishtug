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
  include NameSearchable
  validates :name, presence: true
  validates :name, uniqueness: true
  has_many :menus, dependent: :destroy
  has_many :add_ons, dependent: :destroy

  accepts_nested_attributes_for :add_ons, allow_destroy: true

  def self.published_menus
    includes(
      menus: [
        :asset,
        :diet_category,
        :unit, :add_ons,
        :menus_add_ons]).where.not(menus: { published_at: nil }).sort
  end

  def self.find_all_menus_by(category_id)
    where(id: category_id).includes(:menus).where.not(menus: { published_at: nil }).sort
  end
end
