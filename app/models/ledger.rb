class Ledger < ApplicationRecord
  enum status: %i[pending_payment paid payment_failed]
  belongs_to :order
  belongs_to :user

  def self.unpaid
    where.not(status: :paid)
  end

  def self.total
    pluck(:amount).inject(:+) || 0
  end
end
