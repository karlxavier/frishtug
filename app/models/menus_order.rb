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
#

class MenusOrder < ApplicationRecord
  include InventoryAccounting
  belongs_to :menu
  belongs_to :order
end
