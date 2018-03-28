# == Schema Information
#
# Table name: menus_orders
#
#  id         :integer          not null, primary key
#  menu_id    :integer
#  order_id   :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  quantity   :integer
#  add_ons    :string           default([]), is an Array
#

class MenusOrder < ApplicationRecord
  enum status: %i[recent updated unchanged]
  belongs_to :menu
  belongs_to :order
  validates :quantity, :menu_id, presence: true
  delegate :id, :name, :price, to: :menu, prefix: true, allow_nil: true

  def add_ons_list
    return nil if add_ons.blank?
    "(#{AddOn.where(id: add_ons).map(&:name).join(', ')})"
  end

  def self.top(number)
    return nil if number.nil?
    joins(:menu).group(:name, :menu_id).order('count_all desc').limit(number).count
  end
end
