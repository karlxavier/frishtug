# == Schema Information
#
# Table name: menus_temp_orders
#
#  id            :integer          not null, primary key
#  menu_id       :integer
#  temp_order_id :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  quantity      :integer          default(0)
#  add_ons       :string           default([]), is an Array
#

class MenusTempOrder < ApplicationRecord
  belongs_to :menu
  belongs_to :temp_order

  delegate :name, :id, :price, to: :menu, prefix: true, allow_nil: true

  def add_ons_list
    "<small>(#{self.add_ons.map { |a| AddOn.find(a).name }.join(', ')})</small>".html_safe
  end
end
