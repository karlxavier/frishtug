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
#  unit_size        :integer
#  item_number      :string
#  tax              :boolean          default(FALSE)
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
  before_save :generate_item_number_from_first_letters_of_name

  scope :filter_by_category, -> (category_id) { where(menu_category_id: category_id) }

  def sanitize_price
    errors.add(:price, 'should be atleast 0.01') if price.nil? || price < 0.01
  end

  def category
    self.menu_category
  end

  def self.shopping_lists?(range)
    where(published: true).includes(:orders).map do |m|
      list_by_range = m.orders.placed_between?(range)
      next unless list_by_range.present?
      {
        menu: m,
        order_ids: list_by_range.pluck(:id)
      }
    end.compact
  end

  private

  def generate_item_number_from_first_letters_of_name
    return if self[:item_number].present?
    generate_item_number(first_letters_of_name)
  end

  def generate_item_number(name)
    random_number = (1..100).to_a.sample(5).join
    name + random_number
  end

  def first_letters_of_name
    self[:name].downcase.split.map(&:chr).join
  end
end
