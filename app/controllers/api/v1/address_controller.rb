class Api::V1::AddressController < Api::V1::BaseController
  def index
    if location
      @coordinates = Geocoder.coordinates(location)
      render json: {
        status: 'success',
        coordinates: @coordinates,
        valid: !@coordinates.nil?
      }, status: :ok
    else
      render json: {
        status: 'error',
        message: 'Please provide a location to check'
      }, status: 400
    end
  end

  private

  def location
    params[:location]
  end
end