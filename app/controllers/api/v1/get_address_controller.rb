class Api::V1::GetAddressController < Api::V1::BaseController
  def index
    @referrer = Referrer.find_by_group_code(group_code)
    if @referrer.present?
      render json: {
        status: 'success',
        address: @referrer.user.active_address
      }, status: :ok
    else
      render json: {
        status: 'error',
        message: 'Group code not found'
      }, status: :not_found
    end
  end

  private

  def group_code
    params[:group_code]
  end
end