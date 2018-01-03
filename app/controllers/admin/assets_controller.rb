class Admin::AssetsController < Admin::BaseController
  skip_before_action :authenticate_admin!, only: :create
  before_action :set_asset, only: :destroy

  def index
    page = params[:page] || 1
    @asset = Asset.new
    @assets = Asset.order('id DESC').page(page).per(20)
  end

  def create
    @asset = Asset.new(asset_params)
    if @asset.save
      render json: { message: 'success', asset_id: @asset.id }, status: 200
    else
      render json: { error: @asset.errors.full_messages.join(', ') }, status: 400
    end
  end

  def destroy
    if @asset.destroy
      redirect_back fallback_location: :back, notice: 'File deleted from server'
    else
      redirect_back fallback_location: :back,
        notice:  @asset.errors.full_messages.join(', ')
    end
  end

  private

  def set_asset
    @asset = Asset.find(params[:id])
  end

  def asset_params
    params.require(:asset).permit(:image)
  end
end
