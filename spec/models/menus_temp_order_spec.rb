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

require 'rails_helper'

RSpec.describe MenusTempOrder, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
