class Admin::DisplayOrdersController < Admin::BaseController
  before_action :set_menu_category
  def create
    if @menu_category.update_attributes(display_params)
      render json: { status: 'success', message: 'Successfully updated display order'}, status: :ok
    else
      render json: { status: 'error', message: @menu_category.errors.full_messages.join(', ') }, status: :unprocessable_entity
    end
  end

  private

  def set_menu_category
    @menu_category = MenuCategory.find(params[:id])
  end

  def display_params
    { display_order: params[:display_order] }
  end
end