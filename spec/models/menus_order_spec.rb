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

require 'rails_helper'

RSpec.describe MenusOrder, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
