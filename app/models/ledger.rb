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
#

class Ledger < ApplicationRecord
  enum status: %i[pending_payment paid payment_failed]
  belongs_to :order
  belongs_to :user
  after_save :destroy_zero_amount

  def self.unpaid
    where.not(status: :paid)
  end

  def self.total
    pluck(:amount).inject(:+) || 0
  end

  private

  def destroy_zero_amount
    if self.amount == 0
      self.destroy
    end
  end
end
