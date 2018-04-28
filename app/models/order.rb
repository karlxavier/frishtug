# == Schema Information
#
# Table name: orders
#
#  id              :integer          not null, primary key
#  user_id         :integer
#  placed_on       :datetime
#  eta             :string
#  delivered_at    :datetime
#  status          :integer
#  remarks         :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  order_date      :datetime
#  series_number   :integer
#  sku             :string
#  delivery_status :integer
#  payment_details :string
#  route_started   :string
#  payment_status  :integer
#

# Column names
# id user_id placed_on:timestamp eta:timestamp delivered_at:timestamp status:integer
class Order < ApplicationRecord
  include Computable
  include UserDelegator
  enum status: %i[processing completed failed cancelled refunded fulfilled fresh]
  enum delivery_status: %i[in_transit received address_not_found]
  enum payment_status: %i[unpaid paid]
  belongs_to :user
  has_many :menus_orders, dependent: :destroy
  has_many :menus, through: :menus_orders
  has_many :bill_histories, dependent: :destroy
  has_one :comment, as: :commentable, dependent: :destroy
  has_one :shipping_charge, dependent: :destroy
  has_many :search_results, as: :searchable
  scope :completed, -> { where.not(delivered_at: nil) }

  accepts_nested_attributes_for :menus_orders, allow_destroy: true

  after_create :set_sku, :set_series_number, :create_pending_credit
  before_save :run_inventory_accounter
  before_destroy :re_account_inventory, prepend: true

  def menu_quantity(menu)
    item =
      menus_orders.where(menu_id: menu.id).first || NullMenuOrders.new(menu)
    item.quantity
  end

  def self.pending_deliveries
    self.active_orders.order(placed_on: :asc).includes(menus: [:menu_category]).map do |o|
      with_shipping = o.user.plan.interval == 'month'
      {
        placed_on: o.placed_on,
        total: OrderCalculator.new(o).total(skip_shipping_fee: with_shipping),
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
    where.not(status: [:fresh, :fulfilled, nil])
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
    order(placed_on: :asc).pluck(:placed_on).map {|p| p.strftime('%Y-%m-%d')}.in_groups_of(5)
  end

  private

  def re_account_inventory
    InventoryAccounter.new(self).re_account
  end

  def create_pending_credit
    blackout_dates = BlackoutDate.pluck_dates
    return unless blackout_dates.include?(placed_on.strftime('%B %d'))
    total = OrderCalculator.new(self).total
    return unless total > 0
    user.pending_credits.create!(
      amount: OrderCalculator.new(self).total,
      activation_date: user.orders.first.placed_on + 28.days,
      placed_on_date: placed_on
    )
  end

  def run_inventory_accounter
    InventoryAccounter.new(self).run if processing? && status_changed?
  end

  def set_sku
    order_id = self[:id].to_s
    self[:sku] = "SKU#{order_id.length >= 4 ? order_id : order_id.rjust(4, '0')}"
  end

  def set_series_number
    self[:series_number] = SeriesCreator.new(self[:placed_on]).create
  end
end
