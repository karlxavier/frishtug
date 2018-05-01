class Api::V1::NutritionalDataController < Api::V1::BaseController
  def index
    nutritional_datas = NutritionalData.all
    render json: {
      status: 'success',
      data: nutritional_datas
    }, status: :ok
  end

  def show
    nutritional_data = NutritionalData.find(params[:id])
    if nutritional_data
      render json: nutritional_data, status: :ok
    else
      render json: { status: 'error', message: 'Not found'}, status: :not_found
    end
  end
end