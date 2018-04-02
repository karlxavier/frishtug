# == Schema Information
#
# Table name: bill_histories
#
#  id          :integer          not null, primary key
#  order_id    :integer
#  user_id     :integer
#  amount_paid :decimal(8, 2)
#  billed_at   :datetime
#  description :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

require 'rails_helper'

RSpec.describe BillHistory, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
