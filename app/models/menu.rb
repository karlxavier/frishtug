# == Schema Information
#
# Table name: menus
#
#  id               :integer          not null, primary key
#  name             :string
#  price            :decimal(8, 2)
#  unit_id          :integer
#  menu_category_id :integer
#  diet_category_id :integer
#  published_at     :datetime
#  published        :boolean
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  image            :string
#

class Menu < ApplicationRecord
  belongs_to :unit
  belongs_to :menu_category
  belongs_to :diet_category, optional: true
  has_and_belongs_to_many :add_ons
  has_and_belongs_to_many :orders
  has_and_belongs_to_many :temp_orders
  validates :name, :unit_id, :menu_category_id, :price, presence: true
  validates :name, uniqueness: true
  validate :sanitize_price

  mount_uploader :image, ImageUploader

  scope :filter_by_category, -> (category_id) { where(menu_category_id: category_id) }

  def sanitize_price
    errors.add(:price, 'should be atleast 0.01') if price.nil? || price < 0.01
  end

  def category
    self.menu_category
  end
end
