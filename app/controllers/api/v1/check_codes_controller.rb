class Api::V1::CheckCodesController < Api::V1::BaseController
  def index
    if group_code.present?
      render json: {
        status: 'success',
        is_valid: Referrer.where(group_code: group_code).any?
      }
    else
      render jsonapi_errors: { status: 'Missing group_code parameter' }
    end
  end

  private

  def group_code
    params[:group_code]
  end
end