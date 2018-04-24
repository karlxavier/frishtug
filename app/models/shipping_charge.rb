# == Schema Information
#
# Table name: shipping_charges
#
#  id         :integer          not null, primary key
#  order_id   :integer
#  charge_id  :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class ShippingCharge < ApplicationRecord
  belongs_to :order
end
