# frozen_string_literal: true

# == Schema Information
#
# Table name: add_ons
#
#  id               :bigint(8)        not null, primary key
#  name             :string
#  menu_category_id :bigint(8)
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  menu_id          :bigint(8)
#

# Class names
# id name menu_category_id
class AddOn < ApplicationRecord
  has_and_belongs_to_many :menus
  belongs_to :menu_category
  validates :name, :menu_category_id, presence: true

  def name_with_price
    "#{name} #{"($ #{format('%.2f', Menu.find(menu_id).price)})" if menu_id}".strip
  end

  def price
    Menu.where(id: menu_id).first&.price || 0
  end

  def self.pluck_prices(column_name)
    prices = Menu.pluck(:id, :price).to_h
    hash = {}
    pluck(column_name.to_sym, :menu_id).map { |a| hash[a[0]] = prices[a[1]] || 0 }
    hash
  end

  def json_string
    {
      id: id,
      price: price,
      name: name
    }.to_json
  end
end
