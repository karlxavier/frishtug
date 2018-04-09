class Api::V1::TaxsController < Api::V1::BaseController
  def index
    @tax = Tax.first
    render json: { status: 'success', data: @tax.rate }, status: :ok
  end
end