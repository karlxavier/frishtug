class Api::V1::AddressController < Api::V1::BaseController
  def index
    @coordinates = Geocoder.coordinates(location)
    if @coordinates.present?
      render json: {
        status: 'success',
        data: @coordinates,
        valid: true
      }, status: :ok
    else
      render json: {
        status: 'success',
        data: @coordinates,
        valid: true #false
      }, status: :ok
    end
  end

  private

  def location
    params[:location]
  end
end