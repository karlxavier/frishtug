class Admin::ShippingPricesController < Admin::BaseController
  before_action :set_shipping_price, only: %i[edit update destroy]
  respond_to :js, only: %i[create update destroy]

  def index
    @shipping_prices = ShippingPrice.all.page(params[:page]).per(20)
  end

  def new
    @shipping_price = ShippingPrice.new
  end

  def create
    @shipping_price = ShippingPrice.new(shipping_price_params)
    if @shipping_price.save
      flash[:success] = "Successfully created."
    else
      flash[:error] = @shipping_price.errors
    end
    respond_with(@shipping_price)
  end

  def edit
  end

  def update
    if @shipping_price.update_attributes(shipping_price_params)
      flash[:success] = "Successfully updated."
    else
      flash[:error] = @shipping_price.errors
    end
    respond_with(@shipping_price)
  end

  def destroy
    flash[:success] = "#{@shipping_price.zip} has been deleted." if @shipping_price.destroy
    respond_with(@shipping_price)
  end

  private

  def set_shipping_price
    @shipping_price = ShippingPrice.find(params[:id])
  end

  def shipping_price_params
    params.require(:shipping_price).permit(:zip, :price)
  end
end
