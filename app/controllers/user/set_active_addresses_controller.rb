class User::SetActiveAddressesController < User::BaseController
  def index
    address = Address.find(address_id)
    if address.active!
      deactivate_user_addresses
      render json: {
        status: 'success',
        addresses: current_user.addresses },
        status: :ok
    else
      render json: {
        status: 'error',
        message: address.errors.full_messages.join(', ') },
        status: :unprocessable_entity
    end
  end

  private

  def address_id
    params[:address_id]
  end

  def deactivate_user_addresses
    current_user.addresses.where.not(id: address_id)
      .map { |a| a.inactive! }
  end
end