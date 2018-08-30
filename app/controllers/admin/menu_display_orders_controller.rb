class Admin::MenuDisplayOrdersController < Admin::BaseController
  before_action :set_menu
  def create
    if @menu.update_attributes(display_params)
      render json: { status: 'success', message: 'Successfully updated display order'}, status: :ok
    else
      render json: { status: 'error', message: @menu.errors.full_messages.join(', ') }, status: :unprocessable_entity
    end
  end

  private

  def set_menu
    @menu = Menu.find(params[:id])
  end

  def display_params
    { display_order: params[:display_order] }
  end
end