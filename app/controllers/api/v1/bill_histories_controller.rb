class Api::V1::BillHistoriesController < Api::V1::BaseController
  before_action :set_user
  def index
    if @user
      @bill_histories = BillHistoryService.new(@user).run
      render json: { status: 'success', data: @bill_histories }, status: :ok
    else
      render json: { status: 'error', message: 'User not found!'}, status: 400
    end
  end

  private

  def set_user
    @user = User.find(params[:id])
  end
end