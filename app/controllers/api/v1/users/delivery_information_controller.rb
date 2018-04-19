class Api::V1::Users::DeliveryInformationController < Api::V1::Users::BaseController
  EXCEPT_COLUMNS = %i[
    created_at
    updated_at
    addressable_type
    addressable_id
    longitude
    latitude
  ].freeze

  def index
    @user_addresses = current_user.addresses.order(:created_at)
    render jsonapi: @user_addresses, status: :ok
  end

  def create
    @delivery_info_form = DeliveryInfoForm.new(
      addresses: address_params,
      current_user: current_user
    )
    save_delivery_info
  end

  def update
    @delivery_info_form = DeliveryInfoForm.new(
      addresses: address_params,
      current_user: current_user
    )
    save_delivery_info
  end

  private

  def save_delivery_info
    if @delivery_info_form.save
      render jsonapi: current_user.addresses, status: :ok
    else
      render json: {
        status: 'error',
        message: @delivery_info_form.errors.full_messages.join(', ')
      }, status: :unprocessable_entity
    end
  end

  def address_params
    params.permit(address: %i[
                    id
                    line1
                    line2
                    front_door
                    state
                    city
                    zip_code
                    location_at
                    _delete
                    status
                  ]).require(:address)
  end
end