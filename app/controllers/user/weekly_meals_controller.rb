class User::WeeklyMealsController < User::BaseController
  before_action :set_temp_order, only: :new
  before_action :set_order_for_edit, :editable?, only: :edit
  before_action :set_category_and_menus, :set_orders_for_option_select, only: %i[new edit]
  before_action :set_date_range, :set_date, only: :index
  respond_to :js, only: :category
  START_DATE = Date.current.beginning_of_week(:sunday)

  def index
    order = current_user.orders
    @active_this_week = order.placed_between?(@date_range).pluck_placed_on
    @not_this_week = order.not_placed_between?(@date_range).pluck_placed_on
    @completed = order.completed.pluck_placed_on
    @orders = order.pending_deliveries
    @order_preference = current_user.order_preference
  end

  def new
    @orders = @temp_order
  end

  def edit
    @orders = @order
  end

  private

  def set_date
    @date = parsed_date(params[:date])
  end

  def set_date_range
    @date_range = DateRange.new(START_DATE, START_DATE.end_of_week(:sunday))
  end

  def parsed_date(date)
    return Date.current unless date
    Date.parse(date)
  end

  def order_date
    Time.zone.parse(params[:date])
  end

  def set_temp_order
    @temp_order = current_user.temp_orders.where(order_date: order_date).first_or_create
  end

  def set_order_for_edit
    current_order = current_user.orders.find_by_placed_on(order_date)
    if current_order.present?
      remove_previous_temp_order unless params[:category].present?
      @order = current_user.temp_orders.where(order_date: order_date).first_or_create
      unless params[:category].present?
        current_order.menus_orders.each do |menu_order|
          @order.menus_temp_orders
            .create!(
              menu_id: menu_order.menu_id,
              quantity: menu_order.quantity,
              add_ons: menu_order.add_ons
            )
        end
      end
    end
  end

  def remove_previous_temp_order
    order = current_user.temp_orders.find_by_order_date(order_date)
    order.destroy if order
  end

  def is_past_noon?
    closed_time = Time.zone.parse '11:00 am'
    order_date.to_date == Date.current.tomorrow && Time.current >= closed_time
  end

  def is_yesterday?
    order_date.to_date < Date.current
  end

  def is_today?
    order_date.to_date == Date.current
  end

  def editable?
    if is_today?
      flash[:error] = 'Too late to edit your meal for today.'
      redirect_back fallback_location: :user_weekly_meals
    end

    if is_past_noon?
      flash[:error] = 'Too late for tomorrow, your meal cannot be changed after 11am.'
      redirect_back fallback_location: :user_weekly_meals
    end

    if is_yesterday?
      flash[:error] = 'Too late to edit your delivered meal.'
      redirect_back fallback_location: :user_weekly_meals
    end
  end

  def set_category_and_menus
    @category = params[:category] || MenuCategory.first.id
    @categories = MenuCategory.all
    @menus = Menu.filter_by_category(@category).has_stock
  end

  def set_orders_for_option_select
    @user_order_options = current_user.orders.map do |o|
      [ o.placed_on.strftime('%^a, %^b %d'), o.id ]
    end.unshift(["Select a date to copy", nil])
  end
end
