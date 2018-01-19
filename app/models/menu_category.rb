# == Schema Information
#
# Table name: menu_categories
#
#  id            :integer          not null, primary key
#  name          :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  display_order :integer
#

# Column names
# id name
class MenuCategory < ApplicationRecord
  default_scope { order(display_order: :asc) }
  include NameSearchable
  has_many :menus, dependent: :destroy
  has_many :add_ons, dependent: :destroy

  validates :name, presence: true, uniqueness: true
  validates :display_order, uniqueness: true

  accepts_nested_attributes_for :add_ons, allow_destroy: true


  def self.published_menus
    includes(
      menus: [
        :asset,
        :diet_categories,
        :unit, :add_ons,
        :menus_add_ons]).where.not(menus: { published_at: nil })
  end

  def self.find_all_menus_by(category_id)
    where(id: category_id).includes(:menus).where.not(menus: { published_at: nil }).sort
  end
end
