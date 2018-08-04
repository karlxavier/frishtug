# frozen_string_literal: true

# == Schema Information
#
# Table name: bill_histories
#
#  id          :bigint(8)        not null, primary key
#  order_id    :bigint(8)
#  user_id     :bigint(8)
#  amount_paid :decimal(8, 2)
#  billed_at   :datetime
#  description :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class BillHistory < ApplicationRecord
  belongs_to :order, optional: true
  belongs_to :user
end
