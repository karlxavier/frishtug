class User::CopyMealsController < User::BaseController

  def create
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

  def save_preference
    if current_user.order_preference
      current_user.order_preference.update_attributes(copy_menu: params[:copy_menu])
    else
      current_user.create_order_preference(copy_menu: params[:copy_menu])
    end
  end
end