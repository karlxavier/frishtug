class Api::V1::NutritionalDataController < Api::V1::BaseController
  def index
    nutritional_datas = NutritionalData.all
    render json: {
      status: 'success',
      data: nutritional_datas
    }, status: :ok
  end

  def show
    # CHANGES: Change parameter to menu_id instead of nutitional id and include menu name for display in modal
    nutritional_data = NutritionalData.nutri_data(params[:id]) 
    if !nutritional_data.empty?
      render json: nutritional_data.first, status: :ok
    else
      render json: { status: 'error', message: 'Not found'}, status: :not_found
    end
  end
end