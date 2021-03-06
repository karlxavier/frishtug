# frozen_string_literal: true

module Computable
  extend ActiveSupport::Concern

  def sub_total
    return 0 unless menus_orders.present?
    OrderCalculator.new(self).total_without_tax
  end

  def total_tax
    return 0 unless menus_orders.present?
    OrderCalculator.new(self).total_tax
  end

  def excess
    return 0 unless menus_orders.present?
    OrderCalculator.new(self).total_excess
  end

  def shipping_fee
    user.plan&.shipping_fee || 0
  end

  def total
    return 0 unless menus_orders.present?
    with_shipping = user&.plan&.interval == 'month'
    OrderCalculator.new(self).total(skip_shipping_fee: with_shipping)
  end
end
