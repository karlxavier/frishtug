class Admin::ConfigsController < Admin::BaseController
  respond_to :js, only: %i[create update]
  before_action :set_store_config, only: :update
  before_action :set_zipcodes, except: :index

  def index
    @store_config = Store.first || Store.new
    @zipcodes = AllowedZipCode.pluck(:zip)
  end

  def create
    @store_config = Store.new(store_config_params)
    if @store_config.save
      @store_config.save_zip(@zipcodes)
      flash[:success] = 'Store config successfully save.'
    else
      flash[:error] = @store_config.errors.full_messages.join(', ')
    end
    respond_with @store_config
  end

  def update
    if @store_config.update(store_config_params)
      @store_config.save_zip(@zipcodes)
      flash[:success] = 'Store config successfully save.'
    else
      flash[:error] = @store_config.errors.full_messages.join(', ')
    end
    respond_with @store_config
  end

  private

  def set_zipcodes
    @zipcodes = params[:zipcodes].split(',')
  end

  def set_store_config
    @store_config = Store.find(params[:id])
  end

  def store_config_params
    params.require(:store).permit(:_id, :_code, {home_page_images: []}, tax_attributes: [ :rate ])
  end
end
