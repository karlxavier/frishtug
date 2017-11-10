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
    @user_addresses = current_user.addresses
    @user_addresses_json = @user_addresses.to_json(except: EXCEPTED_COLUMNS)
  end

  def create
    if save_addresses
      render json: response_message('success', 'Address updated!'), status: :ok
    else
      # message = @address.errors.full_messages.join(', ')
      render json: response_message('error', @errors), status: :unprocessable_entity
    end
  end

  private

  def save_addresses
    ActiveRecord::Base.transaction do
      address_params.each do |address_param|
        if address_param[:id] == nil
          address_param = address_param.except(:id)
          current_user.addresses.create!(address_param)
        else
          address = Address.find(address_param[:id])
          address.update_attributes!(address_param)
        end
      end
    end
    true
  rescue ActiveRecord::StatementInvalid => e
    @errors = e.message
    false
  end

  def response_message(status, message)
    {
      status: status,
      message: message
    }
  end

  def address_params
    params.permit(address: [:id, :line1, :line2, :front_door, :state, :city, :zip_code, :location_at]).require(:address)
  end
end
