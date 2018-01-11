class OrderCopier
  include ActiveModel::Validations
  validates :last_five_orders, presence: true

  attr_accessor :ids

  def initialize(last_five_orders, user)
    @user = user
    @last_five_orders = last_five_orders
    @index = 1
    @fifteen_days = 15
    @day = 0
    @ids = []
    @params
    valid?
  end

  def run
    return false unless @user.order_preference&.copy_menu
    placed_on_date = @last_five_orders.last.placed_on + 1.days
    ActiveRecord::Base.transaction do
      while @index <= @fifteen_days do
        placed_on_date = new_placed_on_date(placed_on_date)
        user_order = @user.orders.create!(order_params(placed_on_date))
        create_menus_orders(user_order)
        @ids << user_order.id
        placed_on_date += 1.days
        @index += 1
      end
    end
    true
  rescue ActiveRecord::StatementInvalid => e
    errors.add(:base, e.message)
    false
  rescue ActiveRecord::RecordInvalid => e
    errors.add(:base, e.message)
    false
  end

  private

  attr_accessor :last_five_orders, :day

  def current_order
    last_five_orders[day - 1]
  end

  def order_params(placed_on_date)
    {
      placed_on: placed_on_date,
      order_date: Time.current,
      remarks: current_order.remarks
    }
  end

  def new_placed_on_date(placed_on_date)
    if placed_on_date.saturday?
      placed_on_date += 1.days
    else
      placed_on_date
    end
  end

  def create_menus_orders(user_order)
    current_order.menus_orders.each do |menu_order|
      user_order.menus_orders.create!(
        menu_id: menu_order.menu_id,
        quantity: menu_order.quantity,
        add_ons: menu_order.add_ons
      )
    end
  end
end