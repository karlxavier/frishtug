# frozen_string_literal: true

# == Schema Information
#
# Table name: ledgers
#
#  id         :bigint(8)        not null, primary key
#  amount     :decimal(8, 2)
#  order_id   :bigint(8)
#  type       :string
#  user_id    :bigint(8)
#  status     :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  charge_id  :string
#

class Ledger < ApplicationRecord
  enum status: %i[pending_payment paid payment_failed cancelled]
  belongs_to :order
  belongs_to :user
  after_save :update_order
  after_update :destroy_zero_amount

  def self.unpaid
    where.not(status: :paid)
  end

  def self.total
    pluck(:amount).inject(:+) || 0
  end

  private

  def destroy_zero_amount
    destroy if amount == 0
  end

  def update_order
    return if %w[pending_payment payment_failed cancelled].include?(status)
    return if amount.nil?
    return if amount <= 0
    types = {
      'TaxLedger': "tax",
      'AdditionalLedger': "excess",
      'ShippingChargeLedger': "shipping",
    }
    order = Order.find(order_id)
    RecordPayments.call(order, amount, types[type.to_sym], charge_id)
    order.update_attributes(
      status: :processing,
      total_price: OrderCalculator.new(order).total,
      charge_id: charge_id,
    )
  end
end
