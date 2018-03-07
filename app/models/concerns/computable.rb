module Computable
  extend ActiveSupport::Concern

  def sub_total
    OrderCalculator.new(self).total_without_shipping
  end

  def excess
    OrderCalculator.new(self).total_excess(self.user.plan.limit)
  end

  def shipping_fee
    user_plan.shipping_fee || 0
  end

  def total
    sub_total.to_f + shipping_fee.to_f
  end
end
