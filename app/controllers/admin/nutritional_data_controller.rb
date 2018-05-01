class Admin::NutritionalDataController < Admin::BaseController
  before_action :set_menu, only: %i[new edit]
  before_action :set_nutritional_data, only: %i[edit update]
  respond_to :js

  def new
    @nutritional_data = @menu.build_nutritional_data
  end

  def edit
  end

  def create
    @nutritional_data = NutritionalData.new(nutritional_data_params)
    if @nutritional_data.save
      render json: { status: 'success', id: @nutritional_data.id }, status: :ok
    else
      render json: { status: 'error', message: @nutritional_data.errors.full_messages.join(', ') }, status: :unprocessable_entity
    end
  end

  def update
    if @nutritional_data.update_attributes(nutritional_data_params)
      render json: { status: 'success', id: @nutritional_data.id }, status: :ok
    else
      render json: { status: 'error', message: @nutritional_data.errors.full_messages.join(', ') }, status: :unprocessable_entity
    end
  end

  def destroy
  end

  private

  def set_menu
    @menu = Menu.find(params[:menu_id])
  end

  def set_nutritional_data
     @nutritional_data = NutritionalData.find(params[:id])
  end

  def nutritional_data_params
    params.require(:nutritional_data).permit(:menu_id, data: {})
  end
end