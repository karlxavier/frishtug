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
  belongs_to :menu
  belongs_to :order
  delegate :id, :name, :price, to: :menu, prefix: true, allow_nil: true

  def add_ons_list
    return nil if add_ons.blank?
    "(#{AddOn.where(id: add_ons).map(&:name).join(', ')})"
  end
end
