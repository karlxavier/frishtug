class Admin::ConfigController < Admin::BaseController
  def index
    @store_config = Store.first || Store.new
  end

  def create
    @store_config = Store.new(store_config_params)
    if @store_config.save
      flash[:success] = 'Store config successfully save.'
    else
      flash[:error] = @store_config.errors.full_messages.join(', ')
    end
    redirect_back fallback_location: :admin_config_index_url
  end

  private

  def store_config_params
    params.fetch(:store, {}).permit(:_id, :_code)
  end
end
