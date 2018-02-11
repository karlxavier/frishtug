# == Schema Information
#
# Table name: add_ons
#
#  id               :integer          not null, primary key
#  name             :string
#  menu_category_id :integer
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  menu_id          :integer
#

# Class names
# id name menu_category_id
class AddOn < ApplicationRecord
  attr_accessor :price
  has_and_belongs_to_many :menus
  belongs_to :menu_category
  validates :name, :menu_category_id, presence: true

  def name_with_price
    "#{name} #{ "($ #{'%.2f' % Menu.find(self.menu_id).price})" if menu_id }".strip
  end

  def price
    Menu.where(id: self.menu_id).first&.price || nil
  end

  def self.pluck_prices(column_name)
    prices = Menu.pluck(:id, :price).to_h
    hash = {}
    pluck(column_name.to_sym, :menu_id).map { |a| hash[a[0]] = prices[a[1]] || 0 }
    hash
  end

  def json_string
    {
      id: self.id,
      price: self.price,
      name: self.name
    }.to_json
  end
end
