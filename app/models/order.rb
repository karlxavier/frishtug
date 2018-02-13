# == Schema Information
#
# Table name: orders
#
#  id            :integer          not null, primary key
#  user_id       :integer
#  placed_on     :datetime
#  eta           :datetime
#  delivered_at  :datetime
#  status        :integer
#  remarks       :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  order_date    :datetime
#  series_number :integer
#

# Column names
# id user_id placed_on:timestamp eta:timestamp delivered_at:timestamp status:integer
class Order < ApplicationRecord
  include Computable
  include UserDelegator
  enum status: %i[processing in_transit completed failed cancelled refunded fulfilled]
  belongs_to :user
  has_many :menus_orders, dependent: :destroy
  has_many :menus, through: :menus_orders
  has_one :comment, as: :commentable, dependent: :destroy
  scope :completed, -> { where.not(delivered_at: nil) }

  before_create :set_series_number
  after_commit :run_inventory_accounter, on: [:create, :update]

  def run_inventory_accounter
    InventoryAccounter.new(self).run if self.processing?
  end

  def set_series_number
    placed_time = self[:placed_on]
    last_series_number = Order.where(placed_on: placed_time.beginning_of_day..placed_time.end_of_day)
      .order(id: :asc).last&.series_number || 0
    self[:series_number] = last_series_number + 1
  end

  def menu_quantity(menu)
    item =
      menus_orders.where(menu_id: menu.id).first || NullMenuOrders.new(menu)
    item.quantity
  end

  def self.pending_deliveries
    where(delivered_at: nil).limit(5).includes(menus: [:menu_category]).map do |o|
      {
        placed_on: o.placed_on,
        menus_orders: o.menus_orders.group_by do |m|
          m.menu.category.name
        end
      }
    end
  end

  def placed_between?(range)
    where(placed_on: range.start_date..range.end_date)
  end

  def self.placed_between?(range)
    where(placed_on: range.start_date..range.end_date)
  end

  def self.active_orders
    where('status != ? OR status IS NULL', Order.statuses[:fulfilled])
  end

  def self.not_placed_between?(range)
    where.not(placed_on: range.start_date..range.end_date)
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

  def self.pluck_placed_on
    order('placed_on ASC').pluck(:placed_on).map {|p| p.strftime('%Y-%m-%d')}.in_groups_of(5)
  end

  def self.selection_dates
    all.in_groups_of(5).map do |o|
      o = o.compact
      if o.count == 5
        ["#{o.first&.placed_on.strftime('%b %d')} - #{o.last&.placed_on.strftime('%b %d')}", o.map(&:id).join(',')]
      end
    end
  end

  def self.available_dates(schedule)
    wdays = %w[sunday monday tuesday wednesday thursday friday]
    last_five_orders = self.last(5)
    last_order_date = last_five_orders.first.placed_on.to_date
    date = last_order_date.next_week(wdays[last_order_date.wday].to_sym)
    results = []
    date -= 1.days
    (0..14).map do |i|
      date += 1.days
      date += 1.days if date.saturday?
      date += 1.days if date.sunday? && schedule == 'monday_to_friday'
      date += 2.days if date.friday? && schedule == 'sunday_to_thursday'
      results << date
    end
    results.in_groups_of(5).map do |r|
      ["#{r.first.strftime('%b %d')} - #{r.last.strftime('%b %d')}", r.join(',')]
    end
  end
end
