# frozen_string_literal: true

class MoneyConverter
  ONE_CENT = 100.0
  attr_reader :amount

  def initialize(amount)
    @amount = amount
  end

  def to_cents
    (amount.to_r * ONE_CENT).to_i
  end

  def to_dollars
    (amount / ONE_CENT).round(2)
  end
end
