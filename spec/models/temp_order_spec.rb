# == Schema Information
#
# Table name: temp_orders
#
#  id         :bigint(8)        not null, primary key
#  user_id    :bigint(8)
#  order_date :datetime
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'rails_helper'

RSpec.describe TempOrder, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
