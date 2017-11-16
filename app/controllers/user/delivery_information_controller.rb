class User::DeliveryInformationController < User::BaseController
  EXCEPTED_COLUMNS = %i[
    created_at
    updated_at
    addressable_type
    addressable_id
    longitude
    latitude
  ].freeze

  def index
    @user_addresses = current_user.addresses.order(:created_at)
    @user_addresses_json = @user_addresses.to_json(except: EXCEPTED_COLUMNS)
  end

  def create
    @delivery_info_form = DeliveryInfoForm.new(
      addresses: address_params,
      current_user: current_user
    )
    if @delivery_info_form.save
      render json: response_message('success', 'Address updated!'), status: :ok
    else
      errors = @delivery_info_form.errors.full_messages.join(', ')
      render json: response_message('error', errors), status: :unprocessable_entity
    end
  end

  private

  def response_message(status, message)
    {
      status: status,
      message: message
    }
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
