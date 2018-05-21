class Api::V1::AddressController < Api::V1::BaseController
  def index
    @command = ValidateAddress.call(address_params)
    if @command.success?
      render json: {
        is_valid: @command.result
      }
    end
  end

  private

  def address_params
    {
      line1: params[:line1],
      line2: params[:line2],
      city: params[:city],
      state: params[:state],
      zip_code: params[:zip_code]
    }
  end
end