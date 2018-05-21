class Api::V1::AddressController < Api::V1::BaseController
  def index
    @coordinates = Geocoder.coordinates(address_params)
    render json: {
      coordinates: @coordinates,
      valid: !@coordinates.blank?
    }, status: :ok
  end

  private

  def address_params
    [
      line1: params[:line1],
      line2: params[:line2],
      city: params[:city],
      state: params[:state],
      zip_code: params[:zip_code]
    ].compact.join(', ')
  end
end