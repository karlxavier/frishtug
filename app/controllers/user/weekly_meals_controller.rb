class User::WeeklyMealsController < User::BaseController
  before_action :user_can_order?, :check_order!, :check_schedule!, :set_new_order, only: :new
  before_action :set_order_for_edit, :editable?, only: :edit
  before_action :set_category_and_menus, :set_orders_for_option_select, only: %i[new edit]
  before_action :user_has_schedule!, :set_date_range, :set_date, only: :index
  respond_to :js, only: :category
  START_DATE = Date.current.beginning_of_week(:sunday)

  def index
    order = current_user.orders
    @active_this_week = order.placed_between?(@date_range).pluck_placed_on
    @active_orders = order.active_orders.pluck_placed_on.last(20)
    @completed = order.completed.pluck_placed_on
    @orders = order.pending_deliveries
    @order_preference = current_user.order_preference
    if current_user.subscribed?
      weekly_scheduler = WeeklyScheduler.new(current_user)
      @from_options = weekly_scheduler.get_schedules_for_selection!
      @to_options = weekly_scheduler.create_schedule_for_selection!
      @available_dates = weekly_scheduler.create_schedule!&.in_groups_of(5, false)
    end
  end

  def new
    if current_user.subscribed?
      weekly_scheduler = WeeklyScheduler.new(current_user)
      dates = weekly_scheduler.create_schedule!&.in_groups_of(5, false)
      @available_dates = dates.first if params[:schedule] == 'second'
      @available_dates = dates.second if params[:schedule] == 'third'
      @available_dates = dates.third if params[:schedule] == 'fourth'
    end
  end

  def edit
  end

  private

  def user_has_schedule!
    return unless current_user.subscribed?
    unless current_user.schedule.present?
      flash[:notice] = "Please select a schedule in the schedule information page"
      redirect_to user_dashboard_index_path
    end
  end

  def check_schedule!
    return unless current_user.subscribed?
    unless params[:schedule].present?
      redirect_back fallback_location: user_weekly_meals_path
    end
  end

  def check_order!
    return unless params[:current_date].present?
  end

  def set_date
    @date = parsed_date(params[:date])
  end

  def set_date_range
    @date_range = DateRange.new(START_DATE, START_DATE.end_of_week(:saturday))
  end

  def parsed_date(date)
    return first_current_order_date unless date
    Date.parse(date)
  end

  def first_current_order_date
    start_date = Date.current.beginning_of_month
    end_date = current_user.orders.last.placed_on.to_date
    range = DateRange.new(start_date, end_date)
    current_user.orders.placed_between?(range).first&.placed_on&.to_date || Date.current
  end

  def placed_on
    Time.zone.parse(params[:date])
  end

  def set_new_order
    @orders = current_user.orders.where(placed_on: placed_on).first_or_create
    @orders.fresh! if @orders.status.nil?
  end

  def set_order_for_edit
    @orders = current_user.orders.includes(menus_orders: :menu).find_by_placed_on(placed_on)
  end

  def is_past_noon?
    closed_time = Time.zone.parse '11:00 am'
    placed_on.to_date == Date.current.tomorrow && Time.current >= closed_time
  end

  def is_yesterday?
    placed_on.to_date < Date.current
  end

  def is_today?
    placed_on.to_date == Date.current
  end

  def editable?
    if is_today?
      flash[:error] = 'Too late to edit your meal for today.'
      redirect_back fallback_location: user_weekly_meals_path
    end

    if is_past_noon?
      flash[:error] = 'Too late for tomorrow, your meal cannot be changed after 11am.'
      redirect_back fallback_location: user_weekly_meals_path
    end

    if is_yesterday?
      flash[:error] = 'Too late to edit your delivered meal.'
      redirect_back fallback_location: user_weekly_meals_path
    end
  end

  def user_can_order?
    return unless user_has_completed_the_plan?
    flash[:error] = 'You can\'t create a new order!'
    redirect_back fallback_location: user_weekly_meals_path
  end

  def user_has_completed_the_plan?
    current_user.subscribed? && current_user.orders_completed?
  end

  def set_category_and_menus
    @category = params[:category] || MenuCategory.first.id
    @categories = MenuCategory.all
    @menus = Menu.includes(:menus_add_ons, :menus_diet_categories)
    .filter_by_category(@category).has_stock
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
