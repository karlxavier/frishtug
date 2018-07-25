class User::CreateNewMonthsController < User::BaseController
  before_action :set_orders_for_option_select, only: :new
  def index
    @schedules = MonthScheduler.new(current_user).create_new_full_month!
    @order_dates = current_user.orders.template.not_empty.pluck(:placed_on).map(&:to_date)
  end

  def create
  end

  def new
    @order = current_user.orders.placed_between?(date_range).first_or_create!(new_order_params)
  end 

  def edit
    @order = current_user.orders.placed_between?(date_range).first
  end

  def update
  end

  private

  def date
    Time.zone.parse(params[:date])
  end

  def date_range
    DateRange.new(date.beginning_of_day, date.end_of_day)
  end

  def new_order_params
    { placed_on: date, order_date: Time.current, status: :template }
  end

  def set_orders_for_option_select
    encountered_dupes = {}
    @user_order_options = []

    options = current_user.orders.map do |o|
      [
        o.menus_orders.map { |i| "#{i.menu_name} x #{i.quantity}"}.join(', '),
        o.id
      ]
    end.unshift(["Select meal to copy", nil])

    options.each do |i|
      unless encountered_dupes[i[0]]
        encountered_dupes[i[0]] = 1
        @user_order_options << i
      end
    end

    @user_order_options
  end
end
