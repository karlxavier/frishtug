class User::CopyMealsController < User::BaseController
  before_action :check_if_orders_complete!

  def create
    @last_five_orders = current_user.orders.where(id: params[:from].split(','))
    @order_copier = OrderCopier.new(@last_five_orders, current_user)

    if @order_copier.copy_to(params[:to].split(','))
      flash[:success] = 'Copy successful!'
      redirect_back fallback_location: :user_weekly_meals
    else
      flash[:error] = @order_copier.errors.full_messages.join(', ')
      redirect_back fallback_location: :user_weekly_meals
    end
  end

  def copy
    save_preference
    @last_five_orders = current_user.orders.last(5)
    @order_copier = OrderCopier.new(@last_five_orders, current_user)

    if @order_copier.run
      render json: { status: 'success', message: 'Menu copied!' }, status: 200
    else
      render json: { status: 'success', message: 'Settings save' }, status: 200
    end
  end

  private

  def check_if_orders_complete!
    if current_user.orders_completed?
      flash[:notice] = 'Cant copy! You have already completed your whole month'
      redirect_back fallback_location: :user_weekly_meals
    end
  end

  def save_preference
    if current_user.order_preference
      current_user.order_preference.update_attributes(copy_menu: params[:copy_menu])
    else
      current_user.create_order_preference(copy_menu: params[:copy_menu])
    end
  end
end