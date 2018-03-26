# == Schema Information
#
# Table name: menus
#
#  id               :integer          not null, primary key
#  name             :string
#  price            :decimal(8, 2)
#  unit_id          :integer
#  menu_category_id :integer
#  published_at     :datetime
#  published        :boolean
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  unit_size        :integer
#  item_number      :string
#  tax              :boolean          default(FALSE)
#  description      :text
#  asset_id         :integer
#

class Menu < ApplicationRecord
  belongs_to  :asset, optional: true
  belongs_to  :unit
  belongs_to  :menu_category, touch: true
  has_one     :inventory, dependent: :destroy
  has_many :search_results, as: :searchable, dependent: :destroy
  has_and_belongs_to_many :add_ons
  has_and_belongs_to_many :diet_categories
  has_many :menus_orders, dependent: :destroy
  has_many :orders, through: :menus_orders
  has_and_belongs_to_many :temp_orders

  validates :name, :unit_id, :menu_category_id, :price, presence: true
  validates :name, uniqueness: true
  validate :sanitize_price
  before_save :generate_item_number_from_first_letters_of_name

  scope :filter_by_category, -> (category_id) { where(menu_category_id: category_id) }


  accepts_nested_attributes_for :inventory, reject_if: ->(attributes){ attributes['quantity'].blank? }, allow_destroy: true

  def category
    self.menu_category
  end

  def self.search(search_term)
    return none if search_term.blank?
    where('name ~* ?', search_term)
  end

  def self.has_stock
    includes(
      :inventory,
      :asset,
      :diet_categories,
      :unit,
      :add_ons,
      :menu_category,
      :menus_add_ons,
      :menus_diet_categories
      )
      .where.not(inventories: { quantity: 0 })
  end

  def self.group_by_category_names
    Rails.cache.fetch([self, "meals_group_by_categories"], expires_in: 12.hours) do
      menu_category_names = MenuCategory.pluck(:id, :name).to_h
      has_stock.where(menu_categories: { part_of_plan: true })
          .order("menu_categories.display_order ASC")
          .group_by { |m| menu_category_names[m.menu_category_id] }
    end
  end

  def self.all_published
    joins(:menu_category).where(published: true)
      .merge(MenuCategory.where.not(name: 'Add-Ons'))
  end

  def self.shopping_lists?(range)
    where(published: true).includes(:orders).map do |m|
      list_by_range = m.orders.placed_between?(range)
      next unless list_by_range.present?
      {
        menu: m,
        order_ids: list_by_range.pluck(:series_number),
        quantity: MenusOrder.where(order_id: list_by_range.pluck(:id)).map(&:quantity).inject(:+)
      }
    end.compact
  end

  def to_json_for_cart(options = {})
    self.as_json(options).merge({quantity: 1, add_ons: []}).to_json
  end

  private

  def sanitize_price
    errors.add(:price, 'should be atleast 0.01') if price && price < 0.01
  end

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
