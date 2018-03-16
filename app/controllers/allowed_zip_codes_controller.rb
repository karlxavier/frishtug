class AllowedZipCodesController < ApplicationController
  def index
    @allowed_zip_codes = AllowedZipCode.pluck(:zip)
    render json: {
      allowed_zip_codes: @allowed_zip_codes
    }, status: :ok
  end
end