# == Schema Information
#
# Table name: orders
#
#  id           :integer          not null, primary key
#  user_id      :integer
#  placed_on    :datetime
#  eta          :datetime
#  delivered_at :datetime
#  status       :integer
#  remarks      :string
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  order_date   :datetime
#

# Column names
# id user_id placed_on:timestamp eta:timestamp delivered_at:timestamp status:integer
class Order < ApplicationRecord
  enum status: %i[in_transit completed]
  belongs_to :user
  has_and_belongs_to_many :menus
  scope :completed, -> { where.not(delivered_at: nil) }

  def self.pending_deliveries
    where(delivered_at: nil).limit(5).includes(menus: [:menu_category]).map do |o|
      {
        placed_on: o.placed_on,
        menus: o.menus.group_by do |m|
          m.category.name
        end
      }
    end
  end

  def self.this_week(start_date = Date.today.beginning_of_week(:sunday))
    end_date = start_date.end_of_week(:sunday)
    where(placed_on: start_date..end_date).includes(menus: [:menu_category]).map do |o|
      {
        placed_on: o.placed_on,
        menus: o.menus.group_by do |m|
          m.category.name
        end
      }
    end
  end

  def grouped_menus
    menus.group_by(&:name).sort
  end

  def self.active_this_week
    start_date = Date.today.beginning_of_week(:sunday)
    end_date = start_date.end_of_week(:sunday)
    where(placed_on: start_date..end_date).map {|a| a.placed_on.strftime('%Y-%m-%d')}
  end

  def self.not_this_week
    start_date = Date.today.beginning_of_week(:sunday)
    end_date = start_date.end_of_week(:sunday)
    where.not(placed_on: start_date..end_date).map {|a| a.placed_on.strftime('%Y-%m-%d')}
  end
end
