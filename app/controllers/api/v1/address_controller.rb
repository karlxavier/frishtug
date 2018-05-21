class Api::V1::AddressController < Api::V1::BaseController
  def index
    invalids = []
    valids = []
    params[:address].each do |key, value|
      command = VerifyAddress.call(address_params(value))
      if !command.success?
        command.errors[:address].map { |e| invalids<<e }
      else
        valids << command.result
      end
    end

    if invalids.count > 0
      render json: {
        errors: invalids.uniq,
        valid: false
      }, status: :ok
    else
      render json: {
        data: valids,
        valid: true
      }, status: :ok
    end
  end

  private

  def address_params(param)
    {
      line1: param[:line1],
      line2: param[:line2],
      city: param[:city],
      state: param[:state],
      zip_code: param[:zip_code]
    }
  end
end