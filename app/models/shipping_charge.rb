# == Schema Information
#
# Table name: shipping_charges
#
#  id         :bigint(8)        not null, primary key
#  order_id   :bigint(8)
#  charge_id  :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class ShippingCharge < ApplicationRecord
  belongs_to :order
end
