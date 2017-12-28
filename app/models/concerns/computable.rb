module Computable
  extend ActiveSupport::Concern

  def sub_total
    menus_orders.map{ |m| m.menu_price * m.quantity }.inject(:+)
  end

  def shipping_fee
    user_plan.shipping_fee || 0
  end

  def total
    sub_total.to_f + shipping_fee.to_f
  end
end
