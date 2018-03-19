class Api::V1::AllowedZipCodesController < Api::V1::BaseController
  def index
    allowed_zip_codes = AllowedZipCode.all
    render jsonapi: allowed_zip_codes
  end
end