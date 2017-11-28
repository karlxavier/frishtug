class User::WeeklyMealsController < User::BaseController
  before_action :set_temp_order, only: :new
  before_action :set_order_for_edit, :editable?, only: :edit
  before_action :set_category_and_menus, only: [:new, :edit]
  respond_to :js, only: :category

  def index
    @date = parsed_date(params[:date])
    order = current_user.orders
    @active_this_week = order.active_this_week
    @not_this_week = order.not_this_week
    @completed = order.completed.map { |o| o.placed_on.strftime('%Y-%m-%d') }
    @orders = order.pending_deliveries
  end

  def new
    @orders = @temp_order
  end

  def edit
    @orders = @order
  end

  private

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
      @order.menu_ids = current_order.menu_ids
    end
  end

  def remove_previous_temp_order
    order = current_user.temp_orders.find_by_order_date(order_date)
    order.destroy if order
  end

  def is_past_noon?
    closed_time = Time.zone.parse '11:00 am'
    order_date.to_date == Date.current.tomorrow + 1 && Time.current >= closed_time
  end

  def is_yesterday?
    order_date.to_date < Date.current
  end

  def editable?
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
    @menus = Menu.filter_by_category(@category)
  end
end
