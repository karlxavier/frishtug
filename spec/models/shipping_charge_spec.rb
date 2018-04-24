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

require 'rails_helper'

RSpec.describe ShippingCharge, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
