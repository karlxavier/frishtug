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
  has_and_belongs_to_many :menus

  def grouped_menus
    menus.group_by(&:name).sort
  end

  def remove_item(item, count = 1)
    current_item_size = self.menus.where(id: item.id).size
    self.menus.delete(item)
    (current_item_size - count).times { self.menus << item }
  end

  def save_as_order!(user)
    ActiveRecord::Base.transaction do
      @order = user.orders.where(placed_on: self.order_date).first_or_create!
      @order.update!(order_date: Time.current)
      @order.menus.clear
      @order.menus << self.menus
      self.destroy
    end
    @order
  rescue ActiveRecord::StatementInvalid => e
    errors.add(:base, e.message)
    false
  end
end
