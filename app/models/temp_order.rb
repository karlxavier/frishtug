# == Schema Information
#
# Table name: temp_orders
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  order_date :datetime
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class TempOrder < ApplicationRecord
  belongs_to :user
  has_many :menus_temp_orders, dependent: :destroy
  has_many :menus, through: :menus_temp_orders

  def menu_quantity(menu)
    item =
      menus_temp_orders.where(menu_id: menu.id).first || NullMenuOrders.new(menu)
    item.quantity
  end

  def total
    total_prices = []
    menus_temp_orders.each do |order|
      total_prices << order.menu_price * order.quantity
      add_on_price = AddOn.where(id: order.add_ons).map(&:price).inject(:+) || 0
      total_prices << add_on_price * order.quantity
    end
    total_prices.compact.inject(:+)
  end

  def grouped_menus
    menus.group_by(&:name).sort
  end

  def store(menu, quantity, add_on_id)
    menu = menus_temp_orders.where(menu_id: menu.id).first_or_create!
    menu.quantity += quantity.to_i
    if add_on_id.present?
      return if menu.add_ons.include?(add_on_id)
      menu.add_ons << AddOn.where(id: add_on_id).first&.id
    end
    menu.save
  end

  def remove_item(menu, quantity, add_on_id)
    menu = menus_temp_orders.where(menu_id: menu.id).first
    menu.quantity -= quantity.to_i
    menu.add_ons.delete_at(menu.add_ons.index(add_on_id)) if add_on_id.present?
    return menu.save if menu.quantity > 0
    menu.destroy
  end

  def save_as_order!(user)
    ActiveRecord::Base.transaction do
      @order = user.orders.where(placed_on: self.order_date).first_or_create!
      @order.update!(order_date: Time.current)
      self.menus_temp_orders.each do |menu_order|
        o = @order.menus_orders.where(menu_id: menu_order.menu_id).first_or_create!
        o.quantity = menu_order.quantity
        o.add_ons = menu_order.add_ons
        o.save
      end
      self.destroy
    end
    @order
  rescue ActiveRecord::StatementInvalid => e
    errors.add(:base, e.message)
    false
  end
end
