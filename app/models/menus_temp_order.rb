# == Schema Information
#
# Table name: menus_temp_orders
#
#  id            :integer          not null, primary key
#  menu_id       :integer
#  temp_order_id :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  quantity      :integer
#

class MenusTempOrder < ApplicationRecord
  belongs_to :menu
  belongs_to :temp_order

  delegate :name, :id, :price, to: :menu, prefix: true, allow_nil: true
end
